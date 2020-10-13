#Investigating data
library(pacman)
p_load(tidyverse, groupdata2, dplyr)
setwd("~/Uni/Bachelor/Data")

demodata <- read_csv("DemoData.csv")

#Number of participants 

demodata  %>% group_by( Gender) %>% summarise(n = n())

#Partitioning function

partition_func <- function(dataframe, hold_size = 0.2, seed){
  set.seed(seed)
  test_females = dataframe %>% filter(Gender == "Female")  %>%  sample_n(round(nrow(dataframe)*hold_size,0)/2)
  train_females = dataframe[dataframe$Gender == "Female" & !dataframe$ID %in% test_females$ID,]
  test_males = dataframe %>% filter(Gender == "Male")  %>%  sample_n(round(nrow(dataframe)*hold_size,0)/2)
  train_males = dataframe[dataframe$Gender == "Male" & !dataframe$ID %in% test_males$ID,]
  holdout = rbind(test_females, test_males)
  train_all = rbind(train_females, train_males)
  return(list(holdout, train_all))
}

splittet_data <- partition_func(demodata, seed = 30)
hold_out <- splittet_data[[1]]
train <- splittet_data[[2]]







