
import pandas as pd
from sklearn.svm import SVC # SVC == support vector classifier
from sklearn.svm import LinearSVC
from sklearn import svm
from sklearn.model_selection import LeaveOneOut #for LOOCV
from sklearn.model_selection import LeaveOneGroupOut #for LOOCV
import numpy as np
from sklearn import datasets

##TEST FOLD 1
testfold_1 = pd.read_csv("test_fold_1.csv", delimiter=',')
testfold_1.head()
testfold_1 = testfold_1.drop(['Unnamed: 0'], axis = 1)

##SVM PREP
#CHANGE GENDER COLUMN TO 1 and 0
testfold_1['Gender'] = testfold_1['Gender'].apply(lambda x: 0 if x=='Male' else 1)
testfold_1['Diagnosis'] = testfold_1['Diagnosis'].apply(lambda x: 0 if x=='TD' else 1)
#subsetting different folds 
test_1 = testfold_1[testfold_1['.folds']==1]
test_1 = test_1.drop(['.folds'], axis = 1)
test_1 = test_1.drop(['ID'], axis = 1)

train_1 = testfold_1[testfold_1['.folds']!=1]
train_1 = train_1.drop(['.folds'], axis = 1)
train_1 = train_1.drop(['ID'], axis = 1)

#making an SVM linear kernel and C=1
X1 = train_1.drop(['Diagnosis'], axis = 1) 
y1 = train_1['Diagnosis']
svc = svm.SVC(C=1, kernel='linear')
svc.fit(X1, y1)
svc.predict(X1_test)#getting predictions

X1_test = test_1.drop(['Diagnosis'], axis = 1)

#getting scores
#Return the mean accuracy on the given test data and labels.
svc.score(X1_test, y1) 
#X : array-like, shape = (n_samples, n_features) - Test samples.
#y : array-like, shape = (n_samples) or (n_samples, n_outputs) - True labels for X.

##TEST FOLD 2
testfold_2 = pd.read_csv("test_fold_2.csv", delimiter=',')
testfold_2.head()
testfold_2 = testfold_2.drop(["Unnamed: 0"], axis = 1)

test_2 = testfold_2[testfold_2['.folds']==2]
train_2 = testfold_1[testfold_2['.folds']!=2]

##TEST FOLD 3
testfold_3 = pd.read_csv("test_fold_3.csv", delimiter=',')
testfold_3.head()
testfold_3 = testfold_3.drop(["Unnamed: 0"], axis = 1)

test_3 = testfold_3[testfold_3['.folds']==3]
train_3 = testfold_3[testfold_3['.folds']!=3]

##TEST FOLD 4
testfold_4 = pd.read_csv("test_fold_4.csv", delimiter=',')
testfold_4.head()
testfold_4 = testfold_4.drop(["Unnamed: 0"], axis = 1)

test_4 = testfold_4[testfold_4['.folds']==4]
train_4 = testfold_4[testfold_4['.folds']!=4]

##TEST FOLD 5
testfold_5 = pd.read_csv("test_fold_5.csv", delimiter=',')
testfold_5.head()
testfold_5 = testfold_5.drop(["Unnamed: 0"], axis = 1)

test_5 = testfold_5[testfold_5['.folds']==5]
train_5 = testfold_5[testfold_5['.folds']!=5]
