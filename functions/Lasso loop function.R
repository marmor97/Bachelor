
#Lasso loop
lasso_function <- function(train_data, folds, id_col, featureset = featureset, language = language){
fold_train <- train_data %>% 
  groupdata2::fold(.,
                   k = folds,
                   id_col = id_col)  #new col called .fold
#for i in nfolds
for(i in (1:length(unique(fold_train$.folds)))){
  print(i)
  lasso_train <- fold_train  %>% 
    filter(.folds != i) %>% 
    select(-c(id_col, trial)) #, .folds
  
  lasso_test <- fold_train  %>% 
    filter(.folds == i)
  
  ###DEFINING VARIABLES
  x <- model.matrix(Diagnosis ~ ., data = lasso_train[,1:(length(lasso_train)-1)]) #making a matrix from formula
  print(nrow(x))
  y <- lasso_train$Diagnosis #choosing the dependent variable
  print(length(y))
  
  ###LASSO
  cv_lasso <- cv.glmnet(x, 
                        y, 
                        alpha = 1, # Setting alpha = 1 implements lasso regression
                        standardize = F,
                        family = "binomial",
                        type.measure = "auc")
  
  
  ###EXTRACTING COEFFICIENTS
  lasso_coef <- tidy(cv_lasso$glmnet.fit) %>%  
    filter(lambda == cv_lasso$lambda.1se,
           term != "(Intercept)") %>% 
    select(term, estimate) %>%  #maybe it arranges with absolute values already
    mutate(abs = abs(estimate),
           term = str_remove_all(term, "`"), 
           lambda_1se = paste(cv_lasso$lambda.1se),
           test_fold = paste(i)) %>% 
    filter(abs > 0)
  
  #Making name for the csvfile
  name <- paste("lasso", featureset, language, "testfold", i, sep = "_")
  #selecting columns to keep in csv file
  print(colnames(train_data))
  if (language == "dk"){
  train_csv <- train_data[,c("ID", "Gender", "Diagnosis", 
                              colnames(train_data[,(colnames(train_data) %in% lasso_coef$term)]))]
  }
  else {
    train_csv <- train_data[,c("ID", "Diagnosis", 
                               colnames(train_data[,(colnames(train_data) %in% lasso_coef$term)]))]
  }
  #writing the csv
  write.csv(train_csv, paste(name, "csv", sep = "."))
  
}
}

#lasso_function(train_scaled, folds = 5, id_col = "ID")
