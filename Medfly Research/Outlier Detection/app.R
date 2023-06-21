library(tidyverse)
library(magrittr)
library(shinydashboard)
library(shiny)
library(plotly)
library(ggplot2)
library(shinyjqui)
library(scales)

remove_shiny_inputs <- function(id, .input) {
  invisible(
    lapply(grep(id, names(.input), value = TRUE), function(i) {
      .subset2(.input, "impl")$.values$remove(i)
    })
  )
}

fly_plot_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("plot_select_input") 
  )
}

fly_plot_module <- function(input,output,session){
    
  plot_reactive <- reactive({
    scale_fun <- function(x) sprintf("%.3f",x)
    row_num <- input$cage %>% as.integer
    gg <-  ggplot(df_nested_hazard$data[[row_num]]) + 
      geom_line(aes(x = df_nested_hazard$data[[row_num]]$age,y = df_nested_hazard$data[[row_num]]$hazard_male,color = "Male"))+
      geom_line(aes(x = df_nested_hazard$data[[row_num]]$age,y = df_nested_hazard$data[[row_num]]$hazard_female,color = "Female"))+
      labs(caption = "(Hazard Function is Log Transformed and on a Log Scale)")+
      xlab("Age")+
      ylab("Hazard")+ 
      scale_y_continuous(trans =log_trans() ,breaks = breaks_log(n = 7,base = exp(1)),labels = scale_fun)+
      scale_color_manual(values = c("pink", "lightblue"),name = "Fly Gender") 
     
     gg %<>% ggplotly %>% config(displayModeBar = FALSE) %>%  layout(annotations = 
                                                                       list(x = 1, y = -0.1, text = "(Hazard Function is Log Transformed)", 
                                                                            showarrow = F, xref='paper', yref='paper', 
                                                                            xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                                                            font=list(size=9, color="#e75480"))
     )
                                                        
    
  }) 
  
  output$plot <- renderPlotly({
      if(input$cage != ""){
        plot_reactive()
      }
    })
  
  output[["plot_select_input"]] <- renderUI({
      ns <- session$ns
      tags$div(id = environment(ns)[["namespace"]],
      tagList(
        box(height = "700px",width = "700px",
 plotlyOutput(ns("plot"),height = "480px",width = "700px"),       
 selectInput(ns("cohort"),label = "Cohort",choices = c(df_nested_male$Cohort)),
selectInput(ns("cage"),label = "Cage",choices = c()),
actionButton(ns('previous_button'),"Previous Cage",icon = icon('chevron-circle-left'),style = 'float: center'),
actionButton(ns('next_button'),"Next Cage" ,icon = icon('chevron-circle-right'),style = 'float: center'),
actionButton(ns('delete_button'),"Remove Plot",icon = icon('times'),style = 'float: right')
)

)
)
})
}

ui <- dashboardPage(
    dashboardHeader(title = "Medfly Research Vizualization"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
      actionButton("add_plot",label = "Add Plot",icon = icon('plus'))
    )
)
server <- function(input, output,session) {
  
   observeEvent(input$add_plot,{
    i <- sprintf('%04d',input$add_plot)
 id <-sprintf('plot_select_input%s',i) 
    
    insertUI(
      selector = '#add_plot',
      where = "beforeBegin",
      ui = 
        column(6,
        fly_plot_ui(id)
        )
        
      
    )
    callModule(fly_plot_module,id)
    observeEvent(input[[paste0(id,'-delete_button')]],{
      removeUI(selector = sprintf('#%s',id))
      remove_shiny_inputs(id,input)
      })
    observeEvent(input[[paste0(id,'-cohort')]], {
        updateSelectInput(session,paste0(id,'-cage'),choices = df_nested_hazard %>% filter(Cohort == input[[paste0(id,'-cohort')]]) %>% extract2("Cage"))
      
    })
    observeEvent(input[[paste0(id,"-next_button")]],{
        if(input[[paste0(id,"-cage")]] %>% as.integer != df_nested_hazard %>% 
                              filter(Cohort == input[[paste0(id,'-cohort')]]) %>% 
                              extract2("Cage") %>% as.integer %>% max){
          
            print(input[[paste0(id,'-cage')]])
        updateSelectInput(session,paste0(id,'-cage'),selected = input[[paste0(id,"-cage")]] %>% as.integer + 1 )
        }
        else{
          
        updateSelectInput(session,paste0(id,'-cage'),
                          selected = df_nested_hazard %>% 
                              filter(Cohort == input[[paste0(id,'-cohort')]]) %>% 
                              extract2("Cage") %>% as.integer %>% min %>% as.character)
            
        }
        
    })
    observeEvent(input[[paste0(id,"-previous_button")]],{
        if(input[[paste0(id,"-cage")]] %>% as.integer != df_nested_hazard %>% 
                              filter(Cohort == input[[paste0(id,'-cohort')]]) %>% 
                              extract2("Cage") %>% as.integer%>% min){
            
        updateSelectInput(session,paste0(id,'-cage'),selected = input[[paste0(id,"-cage")]] %>% as.integer - 1 )
        }
        else{
        updateSelectInput(session,paste0(id,'-cage'),
                          selected = df_nested_hazard %>% 
                              filter(Cohort == input[[paste0(id,'-cohort')]]) %>% 
                              extract2("Cage") %>% as.integer %>% max %>% as.character)
            
        }
        
    })
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
