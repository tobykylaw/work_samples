"""
Homework 2: Similarity Measures on time series and graphs
Course    : Data Mining (636-0018-00L)

Main program.

"""

from __future__ import division, print_function
import argparse
import os
import numpy as np
import collections as coll
import dynamic_time_warping as d


DIST_METRICS = {"manhattan_dist": d.manhattan_dist,
                "DTW0": lambda t1, t2: d.constrained_dtw(t1, t2, 0),
                "DTW10": lambda t1, t2: d.constrained_dtw(t1, t2, 10),
                "DTW25": lambda t1, t2: d.constrained_dtw(t1, t2, 25),
                "DTW_infinity": lambda t1, t2: d.constrained_dtw(t1, t2, float('inf'))}
                

def obtain_pairwise_distances(lst_vec1, lst_vec2, num_comparisons):
    """
    Function obtain_pairwise_distances
    It receives two lists of vectors (normal and abnormal) and computes the Manhattan and DTW distances between
    the vectors in the two lists.

    Returns a vector with average distances per metric. They are ordered identically to the metric names in DIST_METRICS.
    """
    # Create an empty vector to recrod the average distance for each metric
    avg_dist = np.zeros(len(DIST_METRICS), dtype=float)
    # Iterate through all metrics
    for i, metric in enumerate(DIST_METRICS):
        # Iterate through all combinations of pairs of vectors
        # Note: the pair (v1, v2) is the same as (v2, v1)
        for idx_g1 in range(len(lst_vec1)):
            for idx_g2 in range(len(lst_vec2)):
                t1 = lst_vec1[idx_g1]
                t2 = lst_vec2[idx_g2]
                # Determine which metric to compute by indexing dictionary
                # Note: Could be alternatively implemented using an if-elif-else chain
                dist = DIST_METRICS[metric](t1, t2)

                # Accumulate the distance values. The average is computed after the loop
                avg_dist[i] = avg_dist[i] + dist

    # Compute the average. Divide by the number of comparisons
    avg_dist = avg_dist / num_comparisons

    return avg_dist

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
file_name = "{}/ECG200_TRAIN.txt".format(args.datadir)
with open(file_name, 'r') as f_in:
    # Create a dictionary of lists. Key to the dictionary is the group name
    ecg_samples = {}
    ecg_samples["abnormal"] = []
    ecg_samples["normal"] = []
    for line in f_in:
        # Remove the trailing newline and separate the fields
        parts = line.rstrip().split(",")

        if parts[0] == "1":
            entry = np.array(parts[1:], dtype=float)
            ecg_samples["normal"].append(entry)
        elif parts[0] == "-1":
             entry = np.array(parts[1:], dtype=float)
             ecg_samples["abnormal"].append(entry)

print

# If the output directory does not exist, then create it
if not os.path.exists(args.outdir):
    os.makedirs(args.outdir)

# Create the output file and fill it with content as required by the specifications
file_name = "{}/timeseries_output.txt".format(args.outdir)
with open(file_name, 'w') as f_out:

    header = ["Pairs of classes", "Manhattan", "DTW, w = 0", "DTW, w = 10", "DTW, w = 25", "DTW, w = inf"]
    for item in header:
        f_out.write(item + "\t")
    f_out.write ("\n")
        
        
    # Create a list with the group names
    lst_groups = list(ecg_samples.keys())

    # Iterate through all combinations of pairs of groups
    for idx_g1 in range(len(lst_groups)):
        for idx_g2 in range(idx_g1, len(lst_groups)):
            group1 = lst_groups[idx_g1]
            group2 = lst_groups[idx_g2]

            # Compute the average distances between all members of both groups
            # The return vector will have one distance per metric analyzed
            # Note: When the distances are within the same group, the number of
            #       comparisons should be decreased:
            num_comparisons = len(ecg_samples[group1]) * len(ecg_samples[group2])
            if group1 == group2:
                # Don't count comparisons of a document to itself
                #   dist(x1, x2) = 0 when x1 = x2

                num_comparisons -= len(ecg_samples[group1])
                

            # Compute the average Manhattan or DTW distances between groups. They have been put into a vector called vec_dist.
            # 
            vec_dist = obtain_pairwise_distances(ecg_samples[group1], ecg_samples[group2], num_comparisons)

            # Transform the vector of distances to a string
            str_dist = "\t".join("{0:.2f}".format(x) for x in vec_dist)

            # Save the output
            f_out.write("{}:{}\t{}\n".format(group1, group2, str_dist))

