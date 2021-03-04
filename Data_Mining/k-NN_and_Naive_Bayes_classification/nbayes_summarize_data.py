"""
Homework 3: k_Nearest Neighbour and Naive Bayes
Course    : Data Mining (636-0018-00L)

Creates a summary of probabilities for each feature/value and class for a breast
cancer dataset. Produces two output summary files, one for each class.

"""
import argparse
import os
import numpy as np
import pandas as pd

#------------------------------------------------------------------------------
# Main Program
#------------------------------------------------------------------------------


# Set up the parsing of command-line arguments
parser = argparse.ArgumentParser(description="Implements k-NN algorithm")
parser.add_argument("--traindir", required=True, 
                    help="Path to input directory with the training data")
parser.add_argument("--outdir", required=True, 
                    help="Path to the output directory, where the output file will be created")
args = parser.parse_args()

# Reading the input file for the training and test datasets
all_tumor_info = pd.read_csv("{}/tumor_info.txt".format(args.traindir),
                             delimiter="\t",
                             names = ["clump", "uniformity", "marginal", "mitoses", "class"])

# Split the entries according to the class column
class_2 = all_tumor_info.loc[all_tumor_info["class"]== 2]
class_4 = all_tumor_info.loc[all_tumor_info["class"]== 4]


# Delete the last column as we won't need it anymore
class_2 = class_2.drop("class", axis = 1)
class_4 = class_4.drop("class", axis = 1)

# For each feature, tally the frequencies each value 1-10 occurs
# and normalize them against the class frequency
class2_tally = class_2.apply(pd.value_counts, normalize = True)
class4_tally = class_4.apply(pd.value_counts, normalize = True)

# Replace the NaN values, which is due to zero frequency for certain values,
# with 0
class2_tally = class2_tally.fillna(0)
class4_tally = class4_tally.fillna(0)

# Round all the values to 3 decimal places
class2_probs = class2_tally.round(decimals = 3)
class4_probs = class4_tally.round(decimals = 3)

# Substitute the current row indexes to fit the requested format
# (labelling as Values 1-10)
values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
class2_probs["Value"] = values
class2_probs.set_index("Value", inplace = True)
class4_probs["Value"] = values
class4_probs.set_index("Value", inplace = True)

# If the output directory does not exist, then create it
if not os.path.exists(args.outdir):
    os.makedirs(args.outdir)

# Create the output files for each class, rounding the values to 3 decimal places
class2_probs.to_csv("{}/output_summary_class_2.txt".format(args.outdir),
                    float_format = '%.3f', index=True, sep = "\t", encoding='utf8')
class4_probs.to_csv("{}/output_summary_class_4.txt".format(args.outdir),
                    float_format = '%.3f', index=True, sep = "\t", encoding='utf8')
