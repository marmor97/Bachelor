set.seed(123)
source("functions/Normalize_function.R")
source("functions/")

# load data




train <- as.matrix(train)

x = as.matrix(train[,1:14]) #predictors
y = as.matrix(train[,15]) #outcome

lambdas_to_try <- 10^seq(-3, 5, length.out = 100)
sample_size <- 
# Setting alpha = 1 implements lasso regression
lasso_cv <- cv.glmnet(x, y, alpha = 1, lambda = lambdas_to_try,
                      standardize = TRUE, nfolds = 10)

#NB if we want to make leave one out CV then we just set nfolds argument
#to be the size of our sample size


lasso_cv <- cv.glmnet(x, y, alpha = 1, lambda = lambdas_to_try,
                      standardize = TRUE, nfolds = sample_size)
