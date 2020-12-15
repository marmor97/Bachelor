library(pacman)
p_load(ggplot2, tidyverse, wesanderson, ggpubr)

####Function that prepares data for plotting####
# files <- list.files(path = "~/Uni/Bachelor/Data/Bachelor/class_reports_dk", 
#                     pattern = "*.csv",
#                     full.names = F)
# regmatches(files[[1]], 
#            gregexpr("[a-z]*", 
#                     files[[1]]))#[[1]]#[3]

prepare_file <- function(filename, path = getwd()) {
  if (regmatches(filename, gregexpr("[a-z]*", filename))[[1]][3] == "dk"){
  filepath = paste0(path, "/class_reports_dk/", filename, sep = "")
  } 
  if (regmatches(filename, gregexpr("[a-z]*", filename))[[1]][3] == "us"){
  filepath = paste0(path, "/class_reports_us/", filename, sep = "")
  }
  file = read_csv(filepath)
  colnames(file)[1] <- "Metric"
  colnames(file)[2] <- "TD"
  colnames(file)[3] <- "ASD"
  colnames(file)[4] <- "Accuracy"
  colnames(file)[5] <- "Macro_avg"
  colnames(file)[6] <- "Weighted_avg"
  file$Fold         <- rep((str_extract(filename,"(\\d)")),4)
  file$Featureset   <- rep(paste0(regmatches(filename, gregexpr("[a-z]*", filename))[[1]][1]),4)
                      if ((regmatches(filename, 
                                      gregexpr("[a-z]*", 
                                      filename))[[1]][5])=="rbf"|(regmatches(filename, 
                                                                         gregexpr("[a-z]*", 
                                                                         filename))[[1]][5]) == "sigmoid"){
  file$Kernel       <- rep(paste0(regmatches(filename,gregexpr("[a-z]*",filename))[[1]][5]),4) } else {
  file$Kernel       <- rep("linear",4)
                     }
                    
  return(file)
}  


plot_performance <- function(data, title){
  data %>% 
    subset(Metric == "f1-score") %>% 
    ggplot(aes(Kernel, Macro_avg, fill = Fold))+
    geom_bar(stat = "summary", position = "dodge")+
    labs(x = "Kernel",y = "F1-score", title = title)+
    scale_fill_manual(values= wes_palette("Rushmore1", n = 5))+
    theme_light()+
    theme(text=element_text(family="serif", size = 20))
}

pre_recall <- function(dataframe, featureset, kernel, title){
  dataframe$Fold = as.numeric(dataframe$Fold)
  data = dataframe %>% 
    filter(Featureset == featureset & Kernel == kernel) %>% 
    filter(Metric == "precision" | Metric == "recall") %>% 
    select(-c(Accuracy, Macro_avg, Weighted_avg)) %>% 
    melt(id.vars = c("Metric", "Featureset", "Kernel", "Fold"), variable.name = "Diagnosis")
  for (i in 1:length(unique(dataframe$Fold))){
    print(i)
    plot = data %>% 
      ggplot(aes(Metric,value, fill = Diagnosis))+
      geom_bar(fun.data = mean_se, stat = "summary", position = "dodge", size = 0.1)+
      labs(title = title, y = "Value")+
      scale_fill_manual(values= wes_palette("Royal1", n = 2))+
      theme_light()+
      theme(text=element_text(family="serif", size = 20))+
      facet_wrap(~Fold, nrow =1, ncol = 5)
  }
  return(plot)
}
