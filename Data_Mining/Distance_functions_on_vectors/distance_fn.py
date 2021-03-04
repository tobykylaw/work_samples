"""
Homework 1: Distance functions on vectors
Course    : Data Mining (636-0018-00L)

Auxiliary functions.

This file implements the distance functions that are invoked from the main
program.
"""
# Author: Damian Roqueiro <damian.roqueiro@bsse.ethz.ch>
# September 2015

from __future__ import division
import numpy as np
import math

def manhattan_dist(v1, v2):

    """"initialize an output vector v3 to store our values for each iteration of the distance function"""
    v3 = np.zeros(len(v1), dtype = float)
    v1 = np.array(v1, dtype = float)
    v2 = np.array(v2, dtype = float)
   
    """"find the absolute difference between each element in the two vectors v1 and v2, then store in v3 """
    for i in range(0,len(v1)):
        v3[i] = abs(v2[i]-v1[i])
    
    output = sum(v3)

    return output


def hamming_dist(v1, v2):

    """"initialize an output vector v3 to store our values for each iteration of the distance function"""
    v3 = np.zeros(len(v1), dtype = float)
    v1 = np.array(v1, dtype = float)
    v2 = np.array(v2, dtype = float)

    """"binarize the input vectors v1 and v2 for the hamming distance"""
    for i in range (0, len(v1)):
        if v1[i] != 0:
            v1[i] = 1
        
    for i in range (0, len(v2)):
        if v2[i] != 0:
            v2[i] = 1

    """"find the absolute difference between each element in the two vectors v1 and v2, then store in v3 """
    for i in range(0,len(v1)):
        v3[i] = abs(v2[i]-v1[i])
    
    output = sum(v3)

    return output


def euclidean_dist(v1, v2):

    """"initialize an output vector v3 to store our values for each iteration of the distance function"""
    v3 = np.zeros(len(v1), dtype = float)
    v1 = np.array(v1, dtype = float)
    v2 = np.array(v2, dtype = float)

    """Finding the square of the difference between each element in v1 and v2, saving in v3"""
    for i in range(0,len(v1)):
        v3[i] = (v2[i]-v1[i])**2

    """Finding the sum of the terms in v3, then taking its square root"""
    output = math.sqrt(sum(v3))

    return output

def chebyshev_dist(v1, v2):

    v3 = np.zeros(len(v1), dtype = float)
    v1 = np.array(v1, dtype = float)
    v2 = np.array(v2, dtype = float)

    """find the absolute difference between each element in the two vectors v1 and v2, then store in v3 """
    for i in range(0,len(v1)):
        v3[i] = abs(v2[i]-v1[i])

    """"find the absolute maximum difference between all of the elements in v1 and v2"""
    output = float(np.amax(v3))

    return output  

def minkowski_dist(v1, v2, d):

    """"initialize an output vector v3 to store our values for each iteration of the distance function"""
    v3 = np.zeros(len(v1), dtype = float)
    v1 = np.array(v1, dtype = float)
    v2 = np.array(v2, dtype = float)

    """implement the calculation for Minkowski distance: taking the absolute difference between each element of v1 and v2
    and raising it the a user-defined power of d"""
    for i in range(0,len(v1)):
        v3[i] = (abs(v2[i]-v1[i]))**d

    """find the sum of the values in v3, and taking its d-root"""
    output = (sum(v3))**(1/d)

    return output
