library(tidyverse)
library(magrittr)
library(shinydashboard)
library(shiny)
library(plotly)

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
    
  
  
  plot_reactive_female <- reactive({
    row_num <- input$cage %>% as.integer
    gg = ggplot(df_nested_female$data[[row_num]]) + 
      geom_line(aes(x = df_nested_female$data[[row_num]]$age, y = df_nested_female$data[[row_num]]$density, color = 'density')) + 
      geom_line(aes(x = df_nested_female$data[[row_num]]$age, y = df_nested_female$data[[row_num]]$survival, color = 'survival')) + 
      geom_line(aes(x = df_nested_female$data[[row_num]]$age,y = df_nested_female$data[[row_num]]$hazard,color = "hazard"))+xlab("Age")+ylab("Density")
    gg %<>% ggplotly 
    
  }) 
  
  
  
  
  plot_reactive_male <- reactive({
    row_num <- input$cage %>% as.integer
    gg = ggplot(df_nested_male$data[[row_num]]) + 
      geom_line(aes(x = df_nested_male$data[[row_num]]$age, y = df_nested_male$data[[row_num]]$density, color = 'density')) + 
      geom_line(aes(x = df_nested_male$data[[row_num]]$age, y = df_nested_male$data[[row_num]]$survival, color = 'survival')) + 
      geom_line(aes(x = df_nested_male$data[[row_num]]$age,y = df_nested_male$data[[row_num]]$hazard,color = "hazard"))+xlab("Age")+ylab("Density")
    gg %<>% ggplotly 
    
  }) 
  
  
  
  output$plot <- renderPlotly({
    if(input$cage != ""){
      if(input$sex == "Male"){
        plot_reactive_male() 
      }
      else{
        plot_reactive_female()
      }
    }
    
    
  })
  
  output[["plot_select_input"]] <- renderUI({
      ns <- session$ns
      tags$div(id = environment(ns)[["namespace"]],
      tagList(
        box(height = "700px",width = "700px",
 plotlyOutput(ns("plot"),height = "380px",width = "700px"),       
 selectInput(ns("sex"),label = "Sex",choices = c("Male","Female")),
 selectInput(ns("cohort"),label = "Cohort",choices = c(df_nested_male$Cohort)),
 selectInput(ns("size"),label = "Size",choices = c(df_nested_male$Size)),
selectInput(ns("cage"),label = "Cage",choices = c()),
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
      # fluidRow(tags$div(id = "first_row"),
      #          verticalLayout(
      #     box( plotlyOutput("plot",height = 250),
      #           selectInput("sex",label = "Sex",choices = c("Male","Female")),
      #           selectInput("cohort",label = "Cohort",choices = c(df_nested_male$Cohort)),
      #           selectInput("size",label = "Size",choices = c(df_nested_male$Size)),
      #           selectInput("cage",label = "Cage",choices = c()),
      #       collapsible = TRUE
      #     )
      # 
      #     )
      #  
      #       
      #   )
      
      
      actionButton("add_plot",label = "Add Plot",icon = icon('plus'))
      
        
    )
    
    
    
    
)
server <- function(input, output,session) {
    
    # observeEvent(input$add_plot,{
    #   insertUI(selector = "#first_row",where = "afterEnd",ui =  box(plotlyOutput("plot_2",height = 250),
    #             selectInput("sex_2",label = "Sex",choices = c("Male","Female")),
    #             selectInput("cohort_2",label = "Cohort",choices = c(df_nested_male$Cohort)),
    #             selectInput("size_2",label = "Size",choices = c(df_nested_male$Size)),
    #             selectInput("cage_2",label = "Cage",choices = c()))
    #   
    #   
    #   )
    #     
    # })
    # 
    # 
    # 
    # observeEvent({input$cohort_2;input$size_2}, {
    #     if(input$sex_2 == "Male"){
    #         updateSelectInput(session,"cage_2",choices = df_nested_male %>% filter(Cohort == input$cohort_2,Size == input$size_2) %>% extract2("Cage")) 
    #     }
    #     else{
    #         updateSelectInput(session,"cage_2",choices = df_nested_female %>% filter(Cohort == input$cohort_2,Size == input$size_2) %>% extract2("Cage")) 
    #     }
    #     
    # })
    # plot_reactive_female <- reactive({
    #     row_num <- input$cage %>% as.integer
    #     gg = ggplot(df_nested_female$data[[row_num]]) + 
    #         geom_line(aes(x = df_nested_female$data[[row_num]]$age, y = df_nested_female$data[[row_num]]$density, color = 'density')) + 
    #         geom_line(aes(x = df_nested_female$data[[row_num]]$age, y = df_nested_female$data[[row_num]]$survival, color = 'survival')) + 
    #         geom_line(aes(x = df_nested_female$data[[row_num]]$age,y = df_nested_female$data[[row_num]]$hazard,color = "hazard"))+xlab("Age")+ylab("Density")
    #     gg %<>% ggplotly 
    #     
    # }) 
    # 
    # plot_reactive_male <- reactive({
    #     row_num <- input$cage %>% as.integer
    #     gg = ggplot(df_nested_male$data[[row_num]]) + 
    #         geom_line(aes(x = df_nested_male$data[[row_num]]$age, y = df_nested_male$data[[row_num]]$density, color = 'density')) + 
    #         geom_line(aes(x = df_nested_male$data[[row_num]]$age, y = df_nested_male$data[[row_num]]$survival, color = 'survival')) + 
    #         geom_line(aes(x = df_nested_male$data[[row_num]]$age,y = df_nested_male$data[[row_num]]$hazard,color = "hazard"))+xlab("Age")+ylab("Density")
    #     gg %<>% ggplotly 
    #     
    # }) 
    # 
    # output$plot <- renderPlotly({
    #     if(input$cage != ""){
    #         if(input$sex == "Male"){
    #             plot_reactive_male() 
    #         }
    #         else{
    #             plot_reactive_female()
    #         }
    #     }
    # }) 
    #  plot_reactive_female_2 <- reactive({
    #     row_num <- input$cage_2 %>% as.integer
    #     gg = ggplot(df_nested_female$data[[row_num]]) + 
    #         geom_line(aes(x = df_nested_female$data[[row_num]]$age, y = df_nested_female$data[[row_num]]$density, color = 'density')) + 
    #         geom_line(aes(x = df_nested_female$data[[row_num]]$age, y = df_nested_female$data[[row_num]]$survival, color = 'survival')) + 
    #         geom_line(aes(x = df_nested_female$data[[row_num]]$age,y = df_nested_female$data[[row_num]]$hazard,color = "hazard")) +xlab("Age")+ylab("Density")
    #     gg %<>% ggplotly 
    #     
    # }) 
    # 
    # plot_reactive_male_2 <- reactive({
    #     row_num <- input$cage_2 %>% as.integer
    #     gg = ggplot(df_nested_male$data[[row_num]]) + 
    #         geom_line(aes(x = df_nested_male$data[[row_num]]$age, y = df_nested_male$data[[row_num]]$density, color = 'density')) + 
    #         geom_line(aes(x = df_nested_male$data[[row_num]]$age, y = df_nested_male$data[[row_num]]$survival, color = 'survival')) + 
    #         geom_line(aes(x = df_nested_male$data[[row_num]]$age,y = df_nested_male$data[[row_num]]$hazard,color = "hazard")) +xlab("Age")+ylab("Density")
    #     gg %<>% ggplotly 
    #     
    # }) 
    # 
    # output$plot_2 <- renderPlotly({
    #     if(input$cage_2 != ""){
    #         if(input$sex_2 == "Male"){
    #             plot_reactive_male_2() 
    #         }
    #         else{
    #             plot_reactive_female_2()
    #         }
    #     }
    # }) 
    # 
 
 
 
  
 
  
  
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
    observeEvent({input[[paste0(id,'-cohort')]];input[[paste0(id,'-size')]]}, {
      if(input[[paste0(id,'-sex')]] == "Male"){
        updateSelectInput(session,paste0(id,'-cage'),choices = df_nested_male %>% filter(Cohort == input[[paste0(id,'-cohort')]],Size == input[[paste0(id,'-size')]]) %>% extract2("Cage"))
      }
      else{
        updateSelectInput(session,paste0(id,'-cage'),choices = df_nested_female %>% filter(Cohort == input[[paste0(id,'-cohort')]],Size == input[[paste0(id,'-size')]]) %>% extract2("Cage"))
      }
      
    })
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
