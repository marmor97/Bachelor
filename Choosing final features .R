library(tidyverse)

# load data
d1 <- read.csv("gemaps.CoefTestFold.5.csv") #
d2 <- read.csv("gemaps.CoefTestFold.5.csv")
d3 <- read.csv("egemaps_us.CoefTestFold.5.csv")
d4 <- read.csv("egemaps.CoefTestFold.5.csv")

# look at data 
summary1 <- d1 %>% group_by(predictor_name) %>% summarise(n=n()) %>% arrange(desc(n))
summary2 <- d2 %>% group_by(predictor_name) %>% summarise(n=n()) %>% arrange(desc(n))
summary3 <- d3 %>% group_by(predictor_name) %>% summarise(n=n()) %>% arrange(desc(n))
summary4 <- d4 %>% group_by(predictor_name) %>% summarise(n=n()) %>% arrange(desc(n))

# filter features names that are in more than 3 folds
summary1f <- summary1 %>% filter(n>3)

# choose these features and take out only the coefs above 0,01
d1_filtered <- d1 %>% 
  filter(d1$predictor_name %in% summary1f$predictor_name) %>% 
  filter(abs(coef) > 0.01) #maybe this should be the mean of the coef in question in all the folds it appears in?


# making into function
filter_func <- function(dataframe, freq_cutoff=3, coef_cutoff){
  summary = dataframe %>% group_by(predictor_name) %>% summarise(n=n()) %>% arrange(desc(n))
  summary = summary %>% filter(n>freq_cutoff)
  dataframe_filtered <- dataframe %>% 
    filter(dataframe$predictor_name %in% summary$predictor_name) %>% 
    filter(abs(coef) > coef_cutoff)
}

# checking function with different cutoffs
f <- filter_func(dataframe = d1, coef_cutoff=0.01)
f1 <- filter_func(dataframe = d1, coef_cutoff=0.1)

# making list of unique features to put into the final SVM
list1 <- unique(as.character(f$predictor_name))
list2 <- unique(as.character(f1$predictor_name))




