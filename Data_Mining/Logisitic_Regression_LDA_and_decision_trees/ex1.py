'''
Skeleton for Homework 4: Logistic Regression and Decision Trees
Part 1: Logistic Regression

Authors: Anja Gumpinger, Dean Bodenham, Bastian Rieck
'''

#!/usr/bin/env python3

import pandas as pd
import numpy as np

from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from sklearn.preprocessing import StandardScaler


def compute_metrics(y_true, y_pred):
    '''
    Computes several quality metrics of the predicted labels and prints
    them to `stdout`.

    :param y_true: true class labels
    :param y_pred: predicted class labels
    '''

    tn, fp, fn, tp = confusion_matrix(y_true, y_pred).ravel()

    print("\n",'Exercise 1.a')
    print('------------')
    print('TP: {0:d}'.format(tp))
    print('FP: {0:d}'.format(fp))
    print('TN: {0:d}'.format(tn))
    print('FN: {0:d}'.format(fn))
    print('Accuracy: {0:.3f}'.format(accuracy_score(y_true, y_pred)))


if __name__ == "__main__":

    ###################################################################
    # Your code goes here.
    ###################################################################
    # Read in the data for the training and test datasets
    df_train = pd.read_csv('data/diabetes_train.csv')
    df_test = pd.read_csv('data/diabetes_test.csv')

    # Extract the first 7 columns to a numpy array, where each item is a row in the
    # input file
    X_train = df_train.iloc[:, 0:7].values
    X_test = df_test.iloc[:, 0:7].values

    # Extract the 8th column with the classification labels to a numpy array
    y_train = df_train.iloc[:, 7].values
    y_test = df_test.iloc[:, 7].values

    # Standardize the datasets using StandardScaler. Now all features are on the same
    # scale, each feature will have values whose mean = 0 and std dev = 1
    # Note that we apply the same scale for our training data and apply to the test set.
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # We train the logistic regression model using the scaled training dataset
    model = LogisticRegression(C=1).fit(X_train_scaled,y_train)

    # Find the coefficients of the logistic regression
    coefficients = model.coef_

    # The model can now be used to compute predictions for the test dataset,
    # which gives an array of predicted labels (0 or 1) for each of the datapoints
    y_pred = model.predict(X_test_scaled)

    # Run the compute_metrics function to evaluate the performance of this logistic
    # regression model on the test dataset. We are essentially comparing the predicted
    # and true labels of the test dataset, computing TP,FP,TN,FN and finding accuracy.
    compute_metrics(y_test,y_pred)

    print("\n",'Exercise 1.b')
    print('------------')
    print('For the diabetes dataset I would choose Logistic Regression, because the',
          'accuracy of the predictions for Logistic Regression is 0.801 which is higher',
          'than 0.771 for LDA.')
          

    print("\n",'Exercise 1.c')
    print('------------')
    print('For another dataset, I would choose Logistic Regression, because LDA makes more',
          'underlying assumptions on the dataset (eg. equal class probability and covariance matrix),',
          'while Logistic Regression is more generally applicable to different datasets.')

    print("\n",'Exercise 1.d')
    print('------------')
    print('Coefficients of the logisitic regression in the order of attributes in the diabetes dataset:')
    print(coefficients)
    print('It appears that the attributes bp and ped contribute most to the prediction.') 
    print('The coefficient for npreg is 0.33.',
          'Calculating the exponential function results in 1.39, which amounts to an',
          'increase in diabetes risk of 39% per additional pregnancy.')
