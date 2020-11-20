

library(pacman)
p_load(ggplot2, tidyverse, wesanderson)
source("functions/Plotting.R")

####Loading rbf data####
rbf_report_1 <- read_csv("gemaps_dk_rbf_ClassificationReport_1.csv")
rbf_report_2 <- read_csv("gemaps_dk_rbf_ClassificationReport_2.csv")
rbf_report_3 <- read_csv("gemaps_dk_rbf_ClassificationReport_3.csv")
rbf_report_4 <- read_csv("gemaps_dk_rbf_ClassificationReport_4.csv")
rbf_report_5 <- read_csv("gemaps_dk_rbf_ClassificationReport_5.csv")

####Loading linear data####
lin_report_1 <- read_csv("gemaps_dk_ClassificationReport_1.csv")
lin_report_2 <- read_csv("gemaps_dk_ClassificationReport_2.csv")
lin_report_3 <- read_csv("gemaps_dk_ClassificationReport_3.csv")
lin_report_4 <- read_csv("gemaps_dk_ClassificationReport_4.csv")
lin_report_5 <- read_csv("gemaps_dk_ClassificationReport_5.csv")

####Loading sigmoid data####
sig_report_1 <- read_csv("gemaps_dk_sigmoid_ClassificationReport_1.csv")
sig_report_2 <- read_csv("gemaps_dk_sigmoid_ClassificationReport_2.csv")
sig_report_3 <- read_csv("gemaps_dk_sigmoid_ClassificationReport_3.csv")
sig_report_4 <- read_csv("gemaps_dk_sigmoid_ClassificationReport_4.csv")
sig_report_5 <- read_csv("gemaps_dk_sigmoid_ClassificationReport_5.csv")

####Making lists####
rbf_report_list <- list(rbf_report_1,rbf_report_2,rbf_report_3,rbf_report_4,rbf_report_5)
lin_report_list <- list(lin_report_1,lin_report_2,lin_report_3,lin_report_4,lin_report_5)
sig_report_list <- list(sig_report_1,sig_report_2,sig_report_3,sig_report_4,sig_report_5)


####Making datasets####
lin_data <- for_plotting(lin_report_list, "linear")
rbf_data <- for_plotting(rbf_report_list, "rbf") 
sig_data <- for_plotting(sig_report_list, "sigmoid")

all_data <- rbind(lin_data,rbf_data,sig_data)


all_data %>% 
  subset(metric == "f1-score") %>% 
  ggplot(aes(Kernel, weighted_avg, fill = Fold))+
  geom_bar(stat = "summary", position = "dodge")+
  labs(x = "Kernel",y = "F1-score", title = "GeMAPS DK")+
  scale_fill_manual(values= wes_palette("Rushmore1", n = 5))+
  theme_light()


source("functions/Plotting.R")
plot_performance(all_data, title = "GeMAPS DK")

####Old test####
Fold <- c(rep("Fold1",3), rep("Fold2",3), rep("Fold3",3), rep("Fold4",3), rep("Fold5",3))
kernel <- c(rep(c("linear", "rbf", "sigmoid"),5))
WAR <- sample(30:100, 15)

data <- data.frame(Fold, kernel, WAR)

Fold <- c(rep("Fold1",3), rep("Fold2",3), rep("Fold3",3), rep("Fold4",3), rep("Fold5",3))
kernel <- c(rep(c("linear", "rbf", "sigmoid"),5))
WAR <- sample(30:100, 15)

data <- data.frame(Fold, kernel, WAR)


