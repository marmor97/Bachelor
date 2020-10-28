
#Lasso loop
lasso_function <- function(train_data, folds, id_col){
fold_train <- train_data %>% 
  groupdata2::fold(.,
                   k = folds,
                   id_col = id_col)  #new col called .fold
#for i in nfolds
for(i in (1:length(unique(fold_train$.folds)))){
  print(i)
  train <- fold_train  %>% 
    filter(.folds != i) %>% 
    select(-c(id_col)) #, .folds
  
  test <- fold_train  %>% 
    filter(.folds == i)
  
  ###DEFINING VARIABLES
  x <- model.matrix(Diagnosis ~ ., data = train[,1:(length(train)-1)]) #making a matrix from formula
  y <- train$Diagnosis#choosing the dependent variable
  
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
  
  name <- paste("lasso_feature_fold",i, sep = "_")
  write.csv(lasso_coef, paste(name, "csv", sep = "."))
  
  test_csv <- test[,c("ID", "Gender", "Diagnosis", 
                            colnames(test[,(colnames(test) %in% lasso_coef$term)]))]
  
  write.csv(test_csv, paste(i, "test_set.csv", sep = "_"))
}
}
