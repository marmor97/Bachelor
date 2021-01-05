#egemaps
files_list <- list.files("../Bachelor_vcode/opensmile_python/opensmile-3.0.0/myconfig/egemaps_output/", pattern = ".csv")
filepath <- "../Bachelor_vcode/opensmile_python/opensmile-3.0.0/myconfig/egemaps_output"
filename <- "egemaps"
combine_files(filepath = filepath, filename = filename, files_list = files_list)
length(files_list)

#gemaps
files_list_gemap <- list.files("../Bachelor_vcode/opensmile_python/opensmile-3.0.0/myconfig/gemaps_output/", pattern = ".csv")
length(files_list_gemap)
filepath_gemap <- "../Bachelor_vcode/opensmile_python/opensmile-3.0.0/myconfig/gemaps_output"
filename_gemap <- "gemaps"
combine_files(filepath = filepath_gemap, filename = filename_gemap, files_list = files_list_gemap)
dk <- read.csv("gemap_dk.csv")


#compare
files_list_compare <- list.files("../Bachelor_vcode/opensmile_python/opensmile-3.0.0/myconfig/compare_output/", pattern = ".csv")
length(files_list_gemap)
filepath_compare <- "../Bachelor_vcode/opensmile_python/opensmile-3.0.0/myconfig/compare_output"
filename_compare <- "compare"
combine_files(filepath = filepath_compare, filename = filename_compare, files_list = files_list_compare)
length(files_list_compare)

combine_files <- function(filepath, filename, files_list){
for (i in 1:length(files_list)){
  print(i)
  file <- read_delim(
    paste(filepath, files_list[i], sep = "/"),
    ";",
    escape_double = FALSE,
    trim_ws = TRUE
  )
  file$ID <-NA
  file$story_type = NA
  file$condition = NA
  file$trial = NA
  file$country <- str_extract(files_list[i],"^[a-z]{2}")
  
  if(file$country == "dk"){
    info_list <- stringr::str_match(files_list[i], ".{2}_([a-z]*)_([0-9A-Z]*)[._]([0-9]*)[_]*([a-z]*)_([a-z]*[_]?[a-z]*)")
    file$ID <- info_list[,3]
    file$condition <- info_list[,2]
    file$trial <- info_list[,4]
    file$feature_set <- info_list[,5]
  }
  
  if(file$country == "us"){ #for US stories you have: us_stories_1956_elephants, us is the language, stories the task, 1956 the ID, elephants the story name
    info_list <-stringr::str_match(files_list[i],
                                   ".{2}_([a-z]*)_([0-9A-Z]*)[._]([0-9]*)[_ ]*([a-z]*)_([a-z]*[_]?[a-z]*)")              
    
    file$story_type <- info_list[,5]
    file$ID <- info_list[,3]
    file$condition <- info_list[,2]
    file$trial <- info_list[,4]
    file$feature_set <- info_list[,6]
  }
  if(i == 1){
    all_files <- file
  }
  else{
    all_files <- rbind(all_files, file)
  }
  #dk <- all_files[all_files$country=="dk",]
  write.csv(all_files[all_files$country=="dk",], paste(filename, "dk.csv", sep = "_"))
  #us <- all_files[all_files$country=="us",]
  write.csv(all_files[all_files$country=="us",], paste(filename, "us.csv", sep = "_"))
}
}
