#Lasso loop
lasso_function <- function(train_data, 
                           folds, 
                           id_col, 
                           featureset = featureset, 
                           language = language,
                           hold_set,
                           demo_set){
  fold_train <- train_data %>% 
    groupdata2::fold(.,
                     k = folds,
                     id_col = id_col)  #new col called .fold
  
  # pacman::p_load(doMC)
  # registerDoMC(cores = 3)
  # print("trying to make specific hold_out")
  # #writing the csv
  # hold_set$ID <- as.character(hold_set$ID)
  # print("ID changed to characther")
  # demo_set <- demo_set %>% select(
  #   Diagnosis,
  #   ID,
  #   Gender
  # )
  # hold_set <- left_join(hold_set, demo_set, by = "ID")
  # print("ID combined with demo")
  
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
    y <- lasso_train$Diagnosis #choosing the dependent variable

    #lambdas <- seq(0.0001, 1000, length = 65000)
    
    ###LASSO
    set.seed(2020)
    cv_lasso <- cv.glmnet(x, 
                          y, 
                          alpha = 1, # Setting alpha = 1 implements lasso regression
                          standardize = F,
                          #lambda = lambdas,
                          family = "binomial",
                          type.measure = "auc")
                           #parallel = TRUE))
    
    
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
    
   # return(cv_lasso) # Do this if you want to get the lambda plot
    
    #Making name for the csvfile
     name <- paste("lasso", featureset, language, "testfold", i, sep = "_")
    # #selecting columns to keep in csv file

       train_csv <- fold_train[,c("ID", "Diagnosis", ".folds",
                                  colnames(fold_train[,(colnames(fold_train) %in% lasso_coef$term)]))]
       hold_out_set <- hold_set[,c("ID", "Diagnosis",
                               colnames(hold_set[,(colnames(hold_set) %in% lasso_coef$term)]))]
     

     
     print("hold out and train set successfully made")
    #writing the csv
     write.csv(train_csv, paste(name, "csv", sep = "."))
     write.csv(hold_out_set, paste("holdout", name, "csv", sep = "."))
     
    
    
  }
}
  
#lasso_function(train_scaled, folds = 5, id_col = "ID")