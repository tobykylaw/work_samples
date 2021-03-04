#!/usr/bin/env python3

'''
Skeleton for Homework 4: Logistic Regression and Decision Trees
Part 2: Decision Trees

Authors: Anja Gumpinger, Bastian Rieck
'''

import numpy as np
import sklearn.datasets
import math

if __name__ == '__main__':

    iris = sklearn.datasets.load_iris()
    X = iris.data
    y = iris.target

    feature_names = iris.feature_names
    num_features = len(set(feature_names))

    ####################################################################
    
    # Main function: Compute the information gain of the split of an attribute
    # for the Iris dataset
    def compute_information_gain(X, y, attribute_index, theta):
        info = compute_information_content(y)
        info_a = compute_information_a(X, y, attribute_index, theta)
        gain = info - info_a
        return gain
    
    # Auxilliary function, splits X and y into two subsets according to the
    # the split defined by a specified attribute and threshold theta
    def split_data(X, y, attribute_index, theta):
        y_D1 = y[np.where(X[:,attribute_index] < theta)]
        y_D2 = y[np.where(X[:,attribute_index] >= theta)]
        return y_D1, y_D2

    # Compute the information content of a subset X with labels y, according to
    # Equation 3 in the hw description
    def compute_information_content(y):
        size_of_subset = len(y)
        label, counts = np.unique(y, return_counts=True)
        info = 0
        for i in range(len(label)):
            class_probability = counts[i]/size_of_subset
            info -= (class_probability)*math.log2(class_probability)
        return info

    # Compute info_A(X) defined in Equation 4 in the hw description, for a dataset
    # X with labels y that is split according to the split defined by a specified
    # attribute and threshold theta
    def compute_information_a(X, y, attribute_index, theta):
        y_D1, y_D2 = split_data(X, y, attribute_index, theta)
        info_D1 = compute_information_content(y_D1)
        info_D2 = compute_information_content(y_D2)
        info_AX = ((len(y_D1)/len(X))*info_D1)+((len(y_D2)/len(X))*info_D2)
        return info_AX

    # Exercise 2.b: finding information gain for the following four splits on the
    # Iris dataset
    information_gain1 = compute_information_gain(X,y,0,5.5)
    information_gain2 = compute_information_gain(X,y,1,3.0)
    information_gain3 = compute_information_gain(X,y,2,2.0)
    information_gain4 = compute_information_gain(X,y,3,1.0)

    ####################################################################

    print("\n",'Exercise 2.b')
    print('------------')

    print('Split (sepal length (cm) < 5.5): information gain = ', '{0:.2f}'.format(information_gain1))
    print('Split (sepal width (cm) < 3.0): information gain = ', '{0:.2f}'.format(information_gain2))
    print('Split (petal length (cm) < 2.0): information gain = ', '{0:.2f}'.format(information_gain3))
    print('Split (petal width (cm) < 1.0): information gain = ', '{0:.2f}'.format(information_gain4))

    print("\n",'Exercise 2.c')
    print('------------')
    print('I would select either one of (petal length (cm) < 2.0) or (petal width (cm) < 1.0) to be the first split, '
          'because they both give the greatest information gain of 0.92 amongst the 4 splits.') 


    ####################################################################
    # Exercise 2.d
    ####################################################################

    # Do _not_ remove this line because you will get different splits
    # which make your results different from the expected ones...
    np.random.seed(42)

    from sklearn.model_selection import KFold
    from sklearn.model_selection import cross_val_score
    from sklearn.tree import DecisionTreeClassifier
    from sklearn.metrics import accuracy_score
    
    # Use KFold to specify the number of folds/subsets we want to split our
    # dataset into for cross-validation. This splits the dataset into n-folds,
    # and for each fold we use 4 of the subsets for training and 1 for testing.
    # The random seed makes sure that the same splits are always obtained.
    kf = KFold(n_splits = 5, shuffle = True)

    # This basically means we split the dataset into subsets according to kf, and for each
    # fold, we train a DecisionTreeClassifier and preform predictions on the test data.
    # For each fold we evaluate the classification performance by returning accuracy.
    # Below we also return the mean accuracy as a percentage.
    clf = DecisionTreeClassifier()
    scores = cross_val_score(clf, X, y, cv = kf, scoring = 'accuracy')

    # We obtain the feature_importances_ for the classifier in each fold, and store them
    # into feature_importances_vec
    feature_importances_vec = []
    for train_index, test_index in kf.split(X,y):
        X_train, y_train = X[train_index], y[train_index]
        X_test, y_test = X[test_index], y[test_index]
        model = clf.fit(X_train, y_train)
        feature_importance = model.feature_importances_
        feature_importances_vec.append(feature_importance)
           

    print("\n",'Exercise 2.d')
    print('------------')

    print("\n",'Accuracy score using cross-validation')
    print('-------------------------------------\n')
    print('The mean accuracy is {:.2%}.'.format(scores.mean()))

    print("\n",'Feature importances for _original_ data set')
    print('-------------------------------------------\n')
    print('The feature_importances_ for each fold of the cross-validation are: \n',
          feature_importances_vec)
    print('For the original data, the most important features are: \n',
          '- petal length \n', '- petal width')
    

    # Create the reduced dataset
    X_reduced = X[y != 2]
    y_reduced = y[y != 2]

    # Again find the feature_importances_, but on the reduced dataset
    feature_importances_vec_reduced = []
    for train_index, test_index in kf.split(X_reduced,y_reduced):
        X_train, y_train = X_reduced[train_index], y_reduced[train_index]
        X_test, y_test = X_reduced[test_index], y_reduced[test_index]
        model = clf.fit(X_train, y_train)
        feature_importance = model.feature_importances_
        feature_importances_vec_reduced.append(feature_importance)
    
    print("\n",'Feature importances for _reduced_ data set')
    print('------------------------------------------\n')
    print('The feature_importances_ for each fold of the cross-validation are: \n',
          feature_importances_vec_reduced)
    print('For the reduced data, the most important feature is: \n',
          '- petal width \n',
          'This means that, for the Iris flower dataset, we can classify between ',
          'the setosa and versicolor species with information on petal width alone.')
