"""
Homework 2: Similarity Measures on time series and graphs
Course    : Data Mining (636-0018-00L)

Auxiliary functions.

This file implements the distance functions that are invoked from the main
program.
"""

from __future__ import division
import numpy as np
import os

def manhattan_dist(t1, t2):

    """"initialize an output vector v3 to store our values for each iteration of the distance function"""
    t3 = np.zeros(len(t1), dtype = float)
    ts_1 = np.array(t1, dtype = float)
    ts_2 = np.array(t2, dtype = float)
   
    """"find the absolute difference between each element in the two vectors v1 and v2, then store in v3 """
    for i in range(0,len(t1)):
        t3[i] = abs(ts_2[i]-ts_1[i])
    
    output = sum(t3)

    return output

def constrained_dtw(t1, t2, w):
    ts_1 = np.array(t1, dtype = float)
    ts_2 = np.array(t2, dtype = float)
    m = len(ts_1)
    n = len(ts_2)
    C = np.zeros((m+1, n+1), dtype = float)

    for i in range (1, m + 1):
        for j in range (1, n + 1):
            C[i,0] = float('inf')
            C[0, j] = float('inf')
        
            if abs(i-j) > w:
                C[i,j] = float('inf')
            
            elif abs(i-j) <= w:
                up = C[i-1, j]
                left = C[i, j-1]
                diag = C[i-1, j-1]
        
                values = [up, left, diag]
        
                min_cost = min(values)
        
                C[i,j] = abs(ts_1[i-1] - ts_2[j-1]) + min_cost


    return C[m,n]
    
