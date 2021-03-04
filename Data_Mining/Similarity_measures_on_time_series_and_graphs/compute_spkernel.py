"""
Homework 2: Similarity Measures on time series and graphs
Course    : Data Mining (636-0018-00L)

Exercise 1: Main program.

"""

from __future__ import division, print_function
import argparse
import os
import numpy as np
import collections as coll
import scipy.io
import shortest_path_kernel as spk

def calculate_pairwise_SPKernel(lst_mat1, lst_mat2, num_comparisons):
    """
    Function calculate_pairwise_SPKernel
    It receives two lists of matrices (normal and abnormal) and computes the SPKernel
    for all of the pairs of adjacency matrices.
    """
    # Create a variable to record the sum and calculate the average SPKernel similarities
    # across the compound groups
    avg_SPK = 0.0
    
    # Iterate through all the combinations of pairs of adjacency matrices
    # Note: the pair (v1, v2) is the same as (v2, v1)
    for idx_g1 in range(len(lst_mat1)):
            for idx_g2 in range(len(lst_mat2)):
                if (lst_mat1 == lst_mat2) and (idx_g1==idx_g2):
                    avg_SPK = avg_SPK
                else:
                    am_1 = lst_mat1[idx_g1]
                    am_2 = lst_mat2[idx_g2]
                    # Find the shortest path matrix using Floyd_Warshall's algorithm
                    S1 = spk.floyd_warshall(am_1)
                    S2 = spk.floyd_warshall(am_2)
                    # Calculate the SPKernel for the current pair of shortest path matrices
                    pair_SPK = spk.spkernel(S1, S2)

                    #Accumulate the SPKernel values
                    avg_SPK += pair_SPK
                    
    # Compute the average SPK by dividing by the number of comparisons
    avg_SPK = avg_SPK / num_comparisons

    return avg_SPK

#------------------------------------------------------------------------------
# Main program
#------------------------------------------------------------------------------

# Set up the parsing of command-line arguments
parser = argparse.ArgumentParser(description="Compute distance functions on vectors")
parser.add_argument("--datadir", required=True, 
                    help="Path to input directory containing the time series data")
parser.add_argument("--outdir", required=True, 
                    help="Path to the output directory, where the output file will be created")
args = parser.parse_args()

# Read the info file with details of the documents to process
# The whole dataset is saved as variable mat.
# Graph labels 'lmutag'(1 or -1, mutagenic or non-mutagenic) are saved as variable label.
# The adjacency matrices of each graph 'am' is saved as variable data
# Here lmutag is reshaped into a vector/array of 1 and -1.
# Here data is a list of matrices/arrays
mat = scipy.io.loadmat("{}/MUTAG.mat".format(args.datadir))
label = np.reshape(mat['lmutag'], (len(mat['lmutag'],)))
data = np.reshape(mat['MUTAG']['am'], (len(label),))


mutag_dic = {}
mutag_dic["mutagenic"] = []
mutag_dic["non-mutagenic"] = []


for i in range(len(label)):
    if label[i] == 1:
        entry = np.array(data[i], dtype = float)
        mutag_dic["mutagenic"].append(entry)
    elif label[i] == -1:
        entry = np.array(data[i], dtype = float)
        mutag_dic["non-mutagenic"].append(entry)

        
# If the output directory does not exist, then create it
if not os.path.exists(args.outdir):
    os.makedirs(args.outdir)


# Create the output file and fill it with content as required by the specifications
file_name = "{}/graphs_output.txt".format(args.outdir)
with open(file_name, 'w') as f_out:

    header = ["Pairs of classes", "SPKernel"]
    for item in header:
        f_out.write(item + "\t")
    f_out.write ("\n")


    # Create a list with the group names
    lst_groups = list(mutag_dic.keys())

    # Iterate through all combinations of pairs of groups
    for idx_g1 in range(len(lst_groups)):
        for idx_g2 in range(idx_g1, len(lst_groups)):
            group1 = lst_groups[idx_g1]
            group2 = lst_groups[idx_g2]

            # Compute the average distances between all members of both groups
            # The return vector will have one distance per metric analyzed
            # Note: When the distances are within the same group, the number of
            #       comparisons should be decreased:
            num_comparisons = len(mutag_dic[group1]) * len(mutag_dic[group2])
            if group1 == group2:
                # Don't count comparisons of a document to itself
                #   dist(x1, x2) = 0 when x1 = x2

                num_comparisons -= len(mutag_dic[group1])
                

            # Compute the average SPKernel similarities between the mutagenic and non-mutagenic compound groups.
            # They have been put into a vector called vec_dist.
            avg_SPK = calculate_pairwise_SPKernel(mutag_dic[group1], mutag_dic[group2], num_comparisons)

             # Transform the vector of distances to a string
            SPKernel = "{0:.2f}".format(avg_SPK)

            # Save the output
            f_out.write("{}:{}\t{}\n".format(group1, group2, SPKernel))
