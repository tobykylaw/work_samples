"""
Homework 2: Similarity measures on time series and graphs
Course    : Data Mining (636-0018-00L)

Auxiliary functions for exercise 2.

This file implements the SPKernel that is invoked from the main
program.
"""

from __future__ import division
import numpy as np

# Implementing Floyd Warshall's algorithm, finding shortest path matrix from
# adjacency matrix of a graph
def floyd_warshall(A):
    SPM = np.array(A, dtype = float)

    # Initialize the nodes where there are no connecting edges (0)
    # to a large value, except the diagonals
    for i in range (len(SPM)):
        for j in range (len(SPM)):
            if (SPM[i,j] == 0 and i!=j):
                SPM[i,j] = 999999

    # For every possible intermediate node k, find if it's shorter than the
    # current path ij, and update the shortest path matrix
    # This returns a shortest path matrix which records the length of the
    # shortest path between node i and j
    for k in range (len(SPM)):
        for i in range (len(SPM)):
            for j in range (len(SPM)):
                if SPM[i,j] > SPM[i,k] + SPM[k,j]:
                    SPM[i,j] = SPM[i,k] + SPM[k,j]

    return SPM

# Implementing SPKernel, where we compare every edge in S1 and S2.
# Since the SPM for an undirected graph is symmetrical, we only consider
# the upper or lower triangular matrices, which we do by executing the script
# only when j>1.
# if S1 and S2 share an edge of the same weight, then similarity score increases.
def spkernel(S1, S2):
    S1_upper = np.array(S1, dtype = float)
    S2_upper = np.array(S2, dtype = float)
    similarity = 0.0

    for i in range (len(S1)):
        for j in range (len(S1)):
            if (j>i):
                for x in range (len(S2)):
                    for y in range (len(S2)):
                        if (y>x):
                            if S1_upper[i,j] == S2_upper[x,y]:
                                similarity += 1.0
                                

    return similarity
                
                
