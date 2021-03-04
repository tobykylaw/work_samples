"""
Homework 3: k_Nearest Neighbour and Naive Bayes
Course    : Data Mining (636-0018-00L)

Implements the k-NN algorithm on a set of microRNA expression levels for
breast cancer patients.

"""

from __future__ import division, print_function
import argparse
import os
import numpy as np
import pandas as pd


#------------------------------------------------------------------------------
# Auxillary functions
#------------------------------------------------------------------------------

def euclidean_dist(v1, v2):

    """"initialize an output vector v3 to store our values for each iteration of the distance function"""
    v3 = np.zeros(len(v1), dtype = float)
    v1 = np.array(v1, dtype = float)
    v2 = np.array(v2, dtype = float)

    """Finding the square of the difference between each element in v1 and v2, saving in v3"""
    for i in range(0,len(v1)):
        v3[i] = (v2[i]-v1[i])**2

    """Finding the sum of the terms in v3, then taking its square root"""
    output = sum(v3)**(1/2)

    return output


"""Compute the distance between a test_patient and all datapoints in the training dataset.
train is train_data_array, test_patient is the vector for current patient
in the test dataset we are looking at. Returns the list of indices for the k training
datapoints closest to the test_patient datapoint"""

def find_nearest_neighbours(train, test_patient, k):
    # Make an empty list to record the distances between the train and test datapoints
    distances = list()
    test_vec = test_patient[1:-1]
    """For each datapoint in the train dataset, find its distance from all
    of the datapoints in the test dataset, record in distances list"""
    for datapoint in train:
        train_vec = datapoint[1:-1]
        dist = euclidean_dist(train_vec, test_vec)
        distances.append(dist)
        
    # Sort the distances list in ascending order and get the k shortest distances
    # Store the indices of the k training datapoints that are closest to the test_patient
    sorted_indices = sorted(range(len(distances)), key = lambda i: distances[i])
    nearest_neighbours = sorted_indices[0:k]

    return nearest_neighbours

def predicted_class(train_phenotype_array, k, train_data_array, test_patient):
    NN_indices = find_nearest_neighbours(train_data_array, test_patient, k)
    # Find the known classes (+ or -) for all the k nearest neighbours of
    # the test_patient
    NN_classes = train_phenotype_array[NN_indices,[1]]

    # Find the predicted class for this test_patient
    plus_count = 0
    minus_count = 0
    prediction = ""
    for i in NN_classes:
        if i == '+':
            plus_count +=1
        elif i == '-':
            minus_count += 1
            
    if plus_count > minus_count:
            prediction = "+"
    elif minus_count > plus_count:
            prediction = "-"
    elif plus_count == minus_count:
            prediction = "k-1"
        
    return prediction        

#------------------------------------------------------------------------------
# Main Program
#------------------------------------------------------------------------------

# Set up the parsing of command-line arguments
parser = argparse.ArgumentParser(description="Implements k-NN algorithm")
parser.add_argument("--traindir", required=True, 
                    help="Path to input directory with the training data")
parser.add_argument("--testdir", required=True, 
                    help="Path to input directory with the test data")
parser.add_argument("--outdir", required=True, 
                    help="Path to the output directory, where the output file will be created")
parser.add_argument("--mink", required=True, type=int, 
                    help="the minimum value of k on which k-NN algorithm will be run")
parser.add_argument("--maxk", required=True, type=int,
                    help="the maximum value of k on which k-NN algorithm will be run")
args = parser.parse_args()


# Reading the input file for the training and test datasets
train_data = pd.read_csv("{}/matrix_mirna_input.txt".format(args.traindir), delimiter="\t")
train_data_phenotype = pd.read_csv("{}/phenotype.txt".format(args.traindir), delimiter="\t")
test_data = pd.read_csv("{}/matrix_mirna_input.txt".format(args.testdir), delimiter="\t")
test_data_phenotype = pd.read_csv("{}/phenotype.txt".format(args.testdir), delimiter="\t")

# Convert the data tables into arrays of vectors of patient miRNA expression
# levels and phenotypes
train_data_array = train_data.to_numpy()
train_phenotype_array = train_data_phenotype.to_numpy()
test_data_array = test_data.to_numpy()
test_phenotype_array = test_data_phenotype.to_numpy()

# Initialize an empty dictionary with k as keys, to record the lists of class predictions
# for datapoints in the test set based on k nearest neighbours
all_k_predictions = {}

# Interate for all user-defined values of k, and for each datapoint in the test set
for k in range(args.mink, args.maxk + 1):
    all_patient_predictions = list()
    for test_patient in test_data_array:
        patient_prediction =  predicted_class(train_phenotype_array, k, train_data_array, test_patient)
        if patient_prediction == "k-1":
            patient_prediction =  predicted_class(train_phenotype_array, k-1, train_data_array, test_patient)
            all_patient_predictions.append(patient_prediction)
        else:
            all_patient_predictions.append(patient_prediction)
    # At last we save the predictions for each datapoint in the test set in
    # the k_predictions dictionary
    all_k_predictions["{}".format(k)] = all_patient_predictions
   
# If the output directory does not exist, then create it
if not os.path.exists(args.outdir):
    os.makedirs(args.outdir)

# Create an numpy array which contains the real_phenotype labels for the test datapoints    
real_phenotypes = test_phenotype_array[:,[1]]


# Open a new file to record the output
file_name = "{}/output_knn.txt".format(args.outdir)
with open(file_name, 'w') as f_out:

# Write the headers for the file 
    header = ["Value of k", "Accuracy", "Precision", "Recall"]
    for item in header:
        f_out.write(item + "\t")
    f_out.write ("\n")
    
    for key in all_k_predictions.keys():
    # Create an output vector to hold the output values
        output_vec = [key]
        TP = 0
        FP = 0
        TN = 0
        FN = 0
        predicted_phenotypes = all_k_predictions[key]
        for i in range(len(predicted_phenotypes)):
            if predicted_phenotypes[i] == "+" and real_phenotypes[i] == "+":
                TP += 1
            elif predicted_phenotypes[i] == "+" and real_phenotypes[i] == "-":
                FP +=1
            elif predicted_phenotypes[i] == "-" and real_phenotypes[i] == "+":
                FN +=1
            elif predicted_phenotypes[i] == "-" and real_phenotypes[i] == "-":
                TN +=1
        accuracy = "{:.2f}".format((TP+TN)/(TP+FP+TN+FN))
        precision = "{:.2f}".format(TP/(TP+FP))
        recall = "{:.2f}".format(TP/(TP+FN))
        output_vec.extend([accuracy, precision, recall])
    
        # Transform the output to a string
        str_dist = "\t".join("{}".format(x) for x in output_vec)
    
        # Save the output
        f_out.write(str_dist + "\n")
