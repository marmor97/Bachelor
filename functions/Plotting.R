library(pacman)
p_load(ggplot2, tidyverse, wesanderson)

####Function that prepares data for plotting####


prepare_file <- function(filename, path = getwd()) {
  filepath = paste0(path, "/class_reports/", filename, sep = "")
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
    ggplot(aes(Kernel, Weighted_avg, fill = Fold))+
    geom_bar(stat = "summary", position = "dodge")+
    labs(x = "Kernel",y = "Performance", title = title)+
    scale_fill_manual(values= wes_palette("Rushmore1", n = 5))+
    theme_light()+
    theme(text=element_text(family="serif"))
}
