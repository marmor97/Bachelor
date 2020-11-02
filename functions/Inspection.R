#Investigating data
library(pacman)
p_load(tidyverse, groupdata2, dplyr)

# demodata <- read.csv("DemoData.csv")
# demodata <- demodata %>% subset(ID != "130" & ID != "104" & ID!= "105" & ID != "111" & ID != "114")
# 
# gemap_us_dk <- read_csv("gemap_all_us_dk_v2.csv")
# colnames(gemap_us_dk)[2] <- "ID"
# 
# gemap_us_dk <- gemap_us_dk %>% 
#   mutate(
#     ID_letter = str_extract(ID, "[A-Z]*"),
#     ID_number = str_extract(ID, "[0-9]*")
#   ) 
# gemap_us_dk$ID
# gemap_us_dk <- gemap_us_dk %>% 
#   unite(ID, ID_letter:ID_number, sep = "")
# 
# gemap_us_dk <- gemap_us_dk %>% subset(ID != "130" & ID != "104" & ID!= "105" & ID != "111" & ID != "114")
# 
# #Number of participants 
# 
# demodata %>% group_by(Gender, Diagnosis) %>% summarise(n())
# 
# #splitting in languages
# dk_demodata <- demodata %>% filter(language =="dk")
# dk_demodata %>% group_by(Diagnosis) %>% summarise(mean_age = mean(Age, na.rm = T),
#                                                sd_age = sd(Age, na.rm = T),
#                                                min_age = min(Age, na.rm = T),
#                                                min_age_years = min_age/12,
#                                                max_age = max(Age, na.rm = T),
#                                                max_age_years = max_age/12,)
# dk_demodata %>% group_by(Diagnosis, Gender) %>% summarise(n())
# 
# 
# us_demodata <- demodata %>% filter(language == "us")
# demodata %>% group_by(Diagnosis) %>% summarise(mean_age = mean(Age, na.rm = T),
#                                                   sd_age = sd(Age, na.rm = T),
#                                                   min_age = min(Age, na.rm = T),
#                                                   min_age_years = min_age/12,
#                                                   max_age = max(Age, na.rm = T),
#                                                   max_age_years = max_age/12,)
# 


#Partitioning function

partition_func <- function(demo, features, hold_size = 0.2, seed=2020, n, language = "dk"){
  set.seed(seed)
  if (language == "dk"){
    #Female holdout ASDs
    demo_hold_fem_ASD = demo %>% filter(Gender == "Female" & Diagnosis == "ASD")  %>%  
      sample_n(round(n*hold_size/2/2,0))
    feat_hold_fem_ASD = features[features$ID %in% demo_hold_fem_ASD$ID,]
    #Female holdout TDs
    demo_hold_fem_TD = demo %>% filter(Gender == "Female" & Diagnosis == "TD")  %>%  
      sample_n(round(n*hold_size/2/2,0))
    feat_hold_fem_TD = features[features$ID %in% demo_hold_fem_TD$ID,]
    #All female holdouts
    feat_hold_fem = rbind(feat_hold_fem_ASD, feat_hold_fem_TD)
    #Train females
    demo_train_fem = demo[demo$Gender == "Female" & !demo$ID %in% feat_hold_fem$ID,]
    feat_train_fem = features[features$ID %in% demo_train_fem$ID,]
    #Male holdout ASDs
    demo_hold_male_ASD = demo %>% filter(Gender == "Male" & Diagnosis == "ASD")  %>%  
      sample_n(round(n*hold_size/2/2,0))
    feat_hold_male_ASD = features[features$ID %in% demo_hold_male_ASD$ID,]
    #Male holdout TDs
    demo_hold_male_TD = demo %>% filter(Gender == "Male" & Diagnosis == "TD")  %>%  
      sample_n(round(n*hold_size/2/2,0))
    feat_hold_male_TD = features[features$ID %in% demo_hold_male_TD$ID,]
    #All male holdouts
    feat_hold_male = rbind(feat_hold_male_ASD, feat_hold_male_TD)
    #Train males
    demo_train_male = demo[demo$Gender == "Male" & !demo$ID %in% feat_hold_male$ID,]
    feat_train_male = features[features$ID %in% demo_train_male$ID,]
    #Combining
    holdout = rbind(feat_hold_fem, feat_hold_male)
    train_all = rbind(feat_train_fem, feat_train_male) 
    }
  if (language == "us"){
    #All females in holdout
    females = demo %>% filter(Gender == "Female")
    feat_hold_fem = features[features$ID %in% females$ID,]
    #Males ASD for holdout
    demo_hold_male_ASD = demo %>% filter(Gender == "Male" & Diagnosis == "ASD") %>% 
      sample_n(round((n*hold_size - (length(unique(feat_hold_fem$ID))) )/2 ))
    feat_hold_male_ASD = features[features$ID %in% demo_hold_male_ASD$ID,]
    #Males TD for holdout
    demo_hold_male_TD = demo %>% filter(Gender == "Male" & Diagnosis == "TD") %>% 
      sample_n(round((n*hold_size - (length(unique(feat_hold_fem$ID))) )/2 ))
    feat_hold_male_TD = features[features$ID %in% demo_hold_male_TD$ID,]
    feat_hold_male = rbind(feat_hold_male_ASD, feat_hold_male_TD)
    #Train males
    demo_train_male = demo[demo$Gender == "Male" & !demo$ID %in% feat_hold_male$ID,]
    train_all = features[features$ID %in% demo_train_male$ID,]
    #Combining
    holdout = rbind(feat_hold_fem, feat_hold_male)
    }
  return(list(holdout, train_all))
}
# 
#  splittet_data <- partition_func(demo = dk_demodata, features = gemap_us_dk, n = 67, language = "dk")
#  hold_out <- splittet_data[[1]]
#  train <- splittet_data[[2]]
#  
#  length(unique(hold_out$ID))

