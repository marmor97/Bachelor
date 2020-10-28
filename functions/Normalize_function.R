library(tidyverse)

# #create 2 dataframes
# col1 <- c(1, 2, 3, 4, 5, 6, 7, 9)
# col2 <- c(3, 4, 5, 6, 7, 3, 5, 5)
# col3 <- c("b", "j", "t", "k", "j", "k", "j", "k")
# df_1 <- data.frame(col1, col2, col3)
# 
# col1 <- c(1, 2, 3, 4, 5, 6, 7, 8)
# col2 <- c(3, 5, 5, 8, 7, 3, 5, 5)
# col3 <- c("b", "j", "t", "k", "j", "k", "j", "k")
# df_2 <- data.frame(col1, col2, col3)


#scaling function
scale_function <- function(df1, df2, datatype){
  if (datatype=="train") {
    for (i in names(df1)){
      if(is.numeric(df1[,i])){
      xmin = min(df1[i])
      xmax = max(df1[i])
      df1[i] <- (df1[i]-xmin)/(xmax - xmin)
      }
    }
  }
  if (datatype == "test"){
    for (i in names(df2)){
      if(is.numeric(df2[,i])){
      xmin = min(df1[i])
      xmax = max(df1[i])
      df2[i] <- (df2[i]-xmin)/(xmax - xmin)
      }
    }
    df1 <-  df2
  }
  return(df1)
}

# test_scaled <- scale_function(df1=df_1, df2=df_2, datatype = "train")




