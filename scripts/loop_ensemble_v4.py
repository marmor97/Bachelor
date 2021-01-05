globals().clear()
import sklearn as sk
from sklearn.svm import SVC
from sklearn.metrics import classification_report, confusion_matrix
import pandas as pd
import numpy as np
from sklearn import svm, datasets
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV
import scipy.stats
from sklearn.metrics import make_scorer, f1_score
from sklearn.model_selection import GroupKFold

np.random.seed(2020)
pd.set_option('display.max_rows', None)

train1 = [pd.read_csv('lasso_egemaps_us_testfold_1.csv', index_col=0),1, 0]
train2 = [pd.read_csv('lasso_egemaps_us_testfold_2.csv', index_col=0),2, 1]
train3 = [pd.read_csv('lasso_egemaps_us_testfold_3.csv', index_col=0),3, 2]
train4 = [pd.read_csv('lasso_egemaps_us_testfold_4.csv', index_col=0),4, 3]
train5 = [pd.read_csv('lasso_egemaps_us_testfold_5.csv', index_col=0),5, 4]

# load hold out sets 
hold1 = pd.read_csv('holdout.lasso_egemaps_us_testfold_1.csv', index_col=0)
hold2 = pd.read_csv('holdout.lasso_egemaps_us_testfold_2.csv', index_col=0)
hold3 = pd.read_csv('holdout.lasso_egemaps_us_testfold_3.csv', index_col=0)
hold4 = pd.read_csv('holdout.lasso_egemaps_us_testfold_4.csv', index_col=0)
hold5 = pd.read_csv('holdout.lasso_egemaps_us_testfold_5.csv', index_col=0)


colnames
pd.DataFrame(list(hold1.columns)[2:len(hold1.columns)])
#US gemaps folds 37, 30, 23, 31, 52
#US egemaps folds 17, 46, 37, 43, 61
#US compare folds 91, 71, 86, 59, 87

#DK gemaps folds 28, 25, 15, 26, 26
#DK egemaps folds 26, 38, 25, 39,  52
#DK compare folds 71, 34, 65, 113, 54


#DK varying in compare from 36 to 115 columns
#US varying in compare from 58 to 93 columns

#For continuous parameters, such as C above, it is important to specify a continuous distribution to take full advantage of the randomization. 
# This way, increasing n_iter will always lead to a finer search.
#https://scikit-learn.org/dev/auto_examples/model_selection/plot_randomized_search.html#sphx-glr-auto-examples-model-selection-plot-randomized-search-py

#sizes of diagnosis
len(train1[0][train1[0]['Diagnosis']=='ASD'])
len(hold1[hold1['Diagnosis']=='ASD'])
 
gkf=GroupKFold(n_splits=5)

####SPECIFYING PARAMETERS####
##SPECIFYING C and gamma PARAM
#C_range = 0.5 ** np.arange(-1, 9) - these are the ranges used --> just pasted numbers in paramgrid 

#gamma_range = 10. ** np.arange(-5, 4) - these are the ranges used --> just pasted numbers in paramgrid 

#old params
#'gamma': [0.03125, 0.0625 , 0.125, 0.25, 0.5, 1, 2, 4, 8]
#[0.861,0.271,0.211, 0.871, 0.641, 0.161,0.351, 0.411,0.691,0.481,0.551,0.711,0.921,0.791,0.281,0.021,0.651,0.031,0.771,0.811,0.751,0.471,0.461,0.061,0.171,0.511,0.781,0.431,0.091,0.911,0.421,0.311,0.121,0.831,
#0.001,0.371,0.841,0.851,0.241,0.441,0.701,0.611,0.041,0.591,0.951,0.011,0.581,0.341,0.231,0.491,0.321,0.761,0.071,0.201,0.671,0.331,0.571,0.821,0.181,0.221,0.561,0.981,0.661,0.971,0.301,0.151,
#0.051,0.741,0.401,0.251,0.881,0.931,0.891,0.991,0.941,0.731,0.141,0.111,0.381,0.451,0.721,0.521,0.131,0.801,0.681,0.261,0.361,0.621,0.901,0.081,0.531,0.191,0.631,0.291,0.961,0.541,0.501,0.601,
#0.391,0.101]

####LINEAR
##SPECIFYING MODEL 'ENGINE' 
param_grid={'C': [2, 1, 0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625, 0.0078125, 0.00390625]}

svc = SVC(kernel='linear', class_weight = 'balanced') #default is gamma scaled, else use gamma='auto' , 

model = GridSearchCV(svc, param_grid, cv=gkf)



####SIGMOID AND RBF
param_grid={'C': [2, 1, 0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625, 0.0078125, 0.00390625], 'gamma': [1.e-05, 1.e-04, 1.e-03, 1.e-02, 1.e-01, 1.e+00, 1.e+01, 1.e+02, 1.e+03]}

svc = SVC(kernel='sigmoid', class_weight = 'balanced') #default is gamma scaled, else use gamma='auto' , 

model = GridSearchCV(svc, param_grid, cv=gkf)


##LISTS
## Making the datasets into a list
datasets = [train1, train2, train3, train4, train5]
## create list of hold out sets 
hold_out = [hold1, hold2, hold3, hold4, hold5]
## creating empty objects to save data in
classif_reports = ["", "", "", "", ""]
conf_mtxs = []
SVM_coef = pd.DataFrame(columns = ['predictor_name', 'coef', 'fold'])
final_predictions = pd.DataFrame(columns = ['true_diagnosis'])

## creating and appending predictions from hold out
final_predictions['true_diagnosis'] = hold1['Diagnosis']
final_predictions['true_diagnosis'] = final_predictions['true_diagnosis'].apply(lambda x: 0 if x=='TD' else 1) # setting TD as 0 and ASD as 1

#define feature set name
feature_set = 'gemaps_dk_linear'
mode = 'hold_out'
save = 'no'


for df, n, k in datasets:
    #rearranging columns
    df['Diagnosis'] = df['Diagnosis'].apply(lambda x: 0 if x=='TD' else 1) # setting TD as 0 and ASD as 1
    
    # Divide the data up into train and test
    df_test = df.loc[df['.folds'] == n]
    df_train = df.loc[df['.folds'] != n]

    # Dividing train and test up into predictor variables, and Diagnosis

    x_train = df_train.iloc[:,3:]
    x_test = df_test.iloc[:,3:]
    x_hold_out = hold_out[k].iloc[:,2:]

    #n_features = x_train.shape[1]
    #print(1 / (n_features * np.array(x_train).var()))

    y_train = df_train.loc[:,'Diagnosis']
    #y_train = y_train.set_index('ID') # Setting index as ID, to be able to map how well the model predicts on genders 
    
    y_test = df_test.loc[:,'Diagnosis']
    #y_test = y_test.set_index('ID') # Setting index as ID, to be able to map how well the model predicts on genders

    y_hold_out = hold_out[k].loc[:,'Diagnosis']
    y_hold_out = y_hold_out.apply(lambda x: 0 if x=='TD' else 1) # setting TD as 0 and ASD as 1

    # Fit the data onto the model
    fitted = model.fit(x_train, y_train.values.ravel(), groups = df_train['ID']) #values.ravel()
    print(fitted.best_estimator_)

    if mode == 'train' :
        print('train')
        predictions = model.predict(x_train)
        report = classification_report(y_train, predictions, output_dict = True)
        matrixx = confusion_matrix(y_train, predictions) 
    elif mode == 'test' :
        print('test')
        predictions = model.predict(x_test)
        report = classification_report(y_test, predictions, output_dict = True)
        matrixx = confusion_matrix(y_test, predictions)   
        #f_scores = sk.metrics.f1_score(y_test, predictions, average='micro') 
    elif mode == 'hold_out' :
        print('hold_out')
        predictions = model.predict(x_hold_out)
        col_diag = "".join([str(n), "_fold_pred"])
        final_predictions[col_diag] = predictions
        report = classification_report(y_hold_out, predictions, output_dict = True)
        matrixx = confusion_matrix(y_hold_out, predictions)
    print(pd.DataFrame(report))    

    report_number = n-1
    classif_reports[report_number] = report
    conf_mtxs.append(matrixx)

    conf_matrix_name = "".join([str(feature_set),"_ConfusionMatrix_", str(n), ".csv"]) 
    classification_report_name = "".join([str(feature_set),"_ClassificationReport_", str(n), ".csv"]) 
    classif_report_fold = pd.DataFrame(classif_reports[k])
    conf_matrix_fold = pd.DataFrame(conf_mtxs[k])
    
    if save == 'yes' :
        conf_matrix_fold.to_csv(conf_matrix_name, sep=',', index = True)
        classif_report_fold.to_csv(classification_report_name, sep=',', index= True)        


final_predictions['majority_diagnosis'] = final_predictions.iloc[:,1:].mode(axis=1)[0]
#this takes the fold columns and sees the 'mode' - The mode of a set of values is the value that appears most often. It can be multiple values.
report_voted = pd.DataFrame(classification_report(final_predictions['true_diagnosis'], final_predictions['majority_diagnosis'], output_dict = True))
report_voted.to_csv("".join([str(feature_set),"_ClassReport_ensemble", ".csv"]), index= True)

matrixx_ens = pd.DataFrame(confusion_matrix(final_predictions['true_diagnosis'], final_predictions['majority_diagnosis']))
matrixx_ens.to_csv("".join([str(feature_set),"_ConfusionMatrix_ensemble", ".csv"]), index= True)

    



