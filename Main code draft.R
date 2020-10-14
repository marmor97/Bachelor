setwd("~/Documents/Bachelor/Bachelor")
set.seed(123)
source("functions/Normalize_function.R")
source("functions/Inspection.R")
library(pacman)
p_load(tidyverse, tidymodels, glmnet, data.table)

# load data
d1 <- read.csv("dk_triangles_136A_1_gemap_all.csv", sep=";")
d2 <- read.csv("dk_triangles_240A_9_gemap_all.csv", sep=";")
d3 <- read.csv("dk_triangles_231A_10_gemap_all.csv", sep=";")
d4 <- read.csv("dk_triangles_232A_1_gemap_all.csv", sep=";")
d5 <- read.csv("dk_triangles_232A_3_gemap_all.csv", sep=";")
d6 <- read.csv("dk_triangles_232A_2_gemap_all.csv", sep=";")

d1$ID <- 136
d2$ID <- 240
d3$ID <- 231
d4$ID <- 232
d5$ID <- 232
d6$ID <- 232

df <- rbind(d1, d2, d3, d4, d5, d6)
demodata <- read_csv("DemoData.csv")

demo_sub <- demodata %>% 
  filter(ID==136 | ID==240|ID==231|ID==232) %>% 
  select(Diagnosis, ID, Gender, language)

data <- merge(df, demo_sub, by="ID")

#partition
partitions <- partition_func(demo = demo_sub, features =  df, n=4)
train <- partitions[[2]]
hold_out <- partitions[[1]]


#normalize
train_scaled <- scale_function(train, hold_out, datatype = "train")
train_scaled$Diagnosis <- as.factor(train_scaled$Diagnosis)



class(train_scaled)
#fjerne inf, fjerne NA og fjerne NAN
var(train_scaled[,11])


badcolumns <- NULL
for (columns in 1:length(train_scaled)){
  if (is.factor(train_scaled[,columns])){
    if(uniqueN(train_scaled[,columns])<2){
     bad_column_name <- colnames(train_scaled)[columns]
     badcolumns <- c(badcolumns, bad_column_name)
    }
  }
  if (is.numeric(train_scaled[,columns])){
    if(var(train_scaled[,columns], na.rm = T)==0|is.na(var(train_scaled[,columns]))){
      bad_column_name <- colnames(train_scaled)[columns]
      badcolumns <- c(badcolumns, bad_column_name)
    }  
  }
}


train_scaled_clean <- train_scaled[ ,!(colnames(train_scaled) %in% c(badcolumns))]

colnames(train_scaled_clean)

x = as.matrix(train_scaled_clean[,1:55]) #predictors
y = as.matrix(train_scaled_clean[,56]) #outcome

lambdas_to_try <- 10^seq(-10, 10, length.out = 10000)
# Setting alpha = 1 implements lasso regression
lasso_cv <- cv.glmnet(x, y, alpha = 1, lambda = lambdas_to_try,
                      standardize = F, nfolds = 6, family = "binomial", type.measure="class")

#NB if we want to make leave one out CV then we just set nfolds argument
#to be the size of our sample size


plot(lasso_cv)

colnames(train_scaled_clean)[56]
