library(pacman)
p_load(ggplot2, tidyverse, wesanderson)

####Function that prepares data for plotting####
for_plotting <- function(data_list, kernel){ #It takes a list of dataframes - one for each fold in the SVMs
  for (i in 1:length(data_list)){ #For all elements in the list
    colnames(data_list[[i]])[6] <- "weighted_avg" #Change column name to better one
    colnames(data_list[[i]])[5] <- "macro_avg"
    colnames(data_list[[i]])[1] <- "metric"
    data_list[[i]][,7] <- paste(i) #Make column with fold number
    colnames(data_list[[i]])[7] <- "Fold" #Change that column name to fold
    data_list[[i]][,8] <- kernel #Make column name with kernel type
    colnames(data_list[[i]])[8] <- "Kernel" #Change that column name
    if (i ==1){
      data <- as.data.frame(data_list[[1]]) #If the first element: initiate dataframe
    }
    if (i != 1){ #All other elements: add to dataframe
      data <- data %>% rbind(data_list[[i]])
    }
  }
  return(data)
}


plot_performance <- function(data, title){
  data %>% 
    subset(metric == "f1-score") %>% 
    ggplot(aes(Kernel, weighted_avg, fill = Fold))+
    geom_bar(stat = "summary", position = "dodge")+
    labs(x = "Kernel",y = "Performance", title = title)+
    scale_fill_manual(values= wes_palette("Rushmore1", n = 5))+
    theme_light()+
    theme(text=element_text(family="serif"))
}
