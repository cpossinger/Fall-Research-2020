library(survminer)
library(readr)
library(magrittr)
library(dplyr)
library(ggplot2)
library(survival)
library(generics)
library(broom)
# : Load Data ####
male <- read_delim("/home/cam/Documents/Reseach Fall 2020/Data/MALE.txt",delim = "    ")
female <- read_delim("/home/cam/Documents/Reseach Fall 2020/Data/FEMALE.txt",delim = "    ")

# : Density Function ####

total_female <- female %>% slice(3718:n()) %>% select(`      Cohort`)
total_female$`      Cohort` %<>% as.numeric 
age <- c(1:173)
female_density <- total_female$`      Cohort` %>% as.vector %>% density
female_density %>% tidy
f_density_plot <- ggplot(total_female,aes(x = age))+ geom_density() 
f_density_plot


total_male <- male %>% slice(3718:n()) %>% select(`      Cohort`)
total_male$`      Cohort` %<>% as.numeric 

male_density <- total_male$`      Cohort` %>% as.vector %>% density
m_density_plot <- ggplot(total_male,aes(x = age))+ geom_density() 
m_density_plot

female_male_total <- tibble("Age" = age,"Female" = total_female$`      Cohort`,
                            "Male" = total_male$`      Cohort`) 
female_histogram <- ggplot(data = female_male_total,aes(x = Female))+geom_histogram(bins = 50,fill = "blue")
female_histogram
female_density_plot <- ggplot(data = female_male_total,aes(x = Female))+geom_density(color = "blue")
female_density_plot


male_histogram <- ggplot(data = female_male_total,aes(x = Male))+geom_histogram(bins = 50,fill = "red")
male_histogram
male_density_plot <- ggplot(data = female_male_total,aes(x = Male))+geom_density(color = "red")
male_density_plot


# : Cumulative Distribution Function ####

female_cdf <- ecdf(female_male_total$Female)
female_cdf(0.0)
female_cdf_plot <- ggplot(female_male_total,aes(x = Female)) + stat_ecdf(geom = "step",pad = FALSE,color = "blue")
female_cdf_plot


male_cdf <- ecdf(female_male_total$Male)
male_cdf(0.0)
male_cdf_plot <- ggplot(female_male_total,aes(x = Male)) + stat_ecdf(geom = "step",pad = FALSE,color = "red")
male_cdf_plot

# : Survival Function ####

female_surv_data_prep <- function(vec,vec_age){
  num_died <- c()
  num_died_final <- c()
  new_age <- c()
  final_vec <- c()
  for(i in vec){
    if(i == 1){
      num_died %<>% append(0) 
    }
    else{
      #print("i -= 1")
      total_minus_item <- (605528)- i
      num_died %<>% append(total_minus_item)
      
    }
  }
    for(k in vec_age){
      if(k == 1){
        num_died_final %<>% append(0) 
      }
      else{
      num_died_final %<>% append(num_died[k]-num_died[k-1])  
      }
      
    }
  
  for(j in vec_age){
 new_age %<>% append(c(rep(j ,num_died_final[j]))) 
  }
  for(l in vec_age){
final_vec %<>% append(c(rep(1,num_died_final[l]))) 
}
final_data <- data.frame("Age" = new_age,"Dead Female Flies" = final_vec)
print(num_died)
print(num_died_final)
return(final_data)
}


female_surv_data <- female_surv_data_prep(female_male_total$Female %>% as.integer,age)

female_surv <- Surv(female_surv_data$Age,female_surv_data$Dead.Female.Flies)

ggsurvplot(
  fit = survfit(Surv(female_surv_data$Age,female_surv_data$Dead.Female.Flies)~1,data = female_surv_data),
  xlab = "Days",
  ylab = "Overall Survival Probability"
)


male_surv_data_prep <- function(vec,vec_age){
  num_died <- c()
  num_died_final <- c()
  new_age <- c()
  final_vec <- c()
  for(i in vec){
     if(i == vec[1]){
       num_died %<>% append(0) 
     }
    else{
      total_minus_item <- (598118)- i
      num_died %<>% append(total_minus_item)
      
    }
  }
    for(k in vec_age){
      if(k == 1){
        num_died_final %<>% append(0) 
      }
      else{
      num_died_final %<>% append(num_died[k]-num_died[k-1])  
      }
      
    }
  print(female_male_total$Male)
  for(j in vec_age){
 new_age %<>% append(c(rep(j ,num_died_final[j]))) 
  }
  for(l in vec_age){
final_vec %<>% append(c(rep(1,num_died_final[l]))) 
}
final_data <- data.frame("Age" = new_age,"Dead Male Flies" = final_vec)
return(final_data)
}



male_surv_data <- male_surv_data_prep(female_male_total$Male %>% as.integer,age)

male_surv <- Surv(male_surv_data$Age,male_surv_data$Dead.Male.Flies)

ggsurvplot(
  fit = survfit(Surv(male_surv_data$Age,male_surv_data$Dead.Male.Flies)~1,data = male_surv_data),
  xlab = "Days",
  ylab = "Overall Survival Probability"
)










