#Investigating data
library(pacman)
p_load(tidyverse, groupdata2, dplyr)

#demodata <- read_csv("DemoData.csv")

#Number of participants 

#demodata  %>% group_by( Gender) %>% summarise(n = n())

#Partitioning function

partition_func <- function(demo, features, hold_size = 0.2, seed=2020, n=158){
  set.seed(seed)
  #Females
  demo_hold_fem = demo %>% filter(Gender == "Female")  %>%  sample_n(round(n*hold_size,0)/2)
  feat_hold_fem = features[features$ID %in% demo_hold_fem$ID,]
  demo_train_fem = demo[demo$Gender == "Female" & !demo$ID %in% demo_hold_fem$ID,]
  feat_train_fem = features[features$ID %in% demo_train_fem$ID,]
  #Males
  demo_hold_male = demo %>% filter(Gender == "Male")  %>%  sample_n(round(n*hold_size,0)/2)
  feat_hold_male = features[features$ID %in% demo_hold_male$ID,]
  demo_train_male = demo[demo$Gender == "Male" & !demo$ID %in% demo_hold_male$ID,]
  feat_train_male = features[features$ID %in% demo_train_male$ID,]
  #Combining
  holdout = rbind(feat_hold_fem, feat_hold_male)
  train_all = rbind(feat_train_fem, feat_train_male)
  return(list(holdout, train_all))
}

#splittet_data <- partition_func(demodata, seed = 30)
#hold_out <- splittet_data[[1]]
#train <- splittet_data[[2]]







