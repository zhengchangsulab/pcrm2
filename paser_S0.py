#!/usr/bin/python
from __future__ import print_function
import pandas as pd
import sys
from collections import OrderedDict
import numpy as np
import glob

def get_tf_index_peaks(tf_peak_number):

    tf_peak_number_dict = OrderedDict()

    with open(tf_peak_number) as fin:
        for line in fin:
            line_split = line.strip().split()
            peaks_number = np.float32(line_split[0])
            tf_index = line_split[1].split("_")[0]
            
            if peaks_number != 0:
                tf_peak_number_dict[tf_index] = peaks_number

    return tf_peak_number_dict


def get_tf_pair_overlap():
    Pair_overlap_dict = OrderedDict()

    pairs_overlap = glob.glob("*overlap_with_others.txt")
    for pair in pairs_overlap:
        with open(pair) as fin:
            for line in fin:
                line_split = line.strip().split(":")
                pair = line_split[0]
                overlap = np.float32((line_split[1]))
                Pair_overlap_dict[pair] = overlap


    return Pair_overlap_dict

def compute_So_matrix(tf_peak_number_dict, Pair_overlap_dict, matrix_name):

    tf_names_list = tf_peak_number_dict.keys()

    S0_matrix = np.ones((len(tf_names_list), len(tf_names_list)), dtype='float32')

    for tf_1 in tf_names_list:
        for tf_2 in tf_names_list:
            key_1 = tf_1+"|"+tf_2
            key_2 = tf_2+"|"+tf_1

            try:
                d_tf_1 = tf_peak_number_dict[tf_1]
                d_tf_2 = tf_peak_number_dict[tf_2]
                pos_1 = tf_names_list.index(tf_1)
                pos_2 = tf_names_list.index(tf_2)
                
                overlap_1 = Pair_overlap_dict[key_1]
                overlap_2 = Pair_overlap_dict[key_2]

                S0_value = (overlap_1/d_tf_1 + overlap_2/d_tf_2)/2
                S0_matrix[pos_1, pos_2] = np.float32(S0_value)
                    
            except:
                pass

    np.save(matrix_name, S0_matrix)

    with open("tf_name_list.txt", "w") as fout:
        for tf in tf_names_list:
            fout.write(tf+"\n")

    df = pd.DataFrame(data=S0_matrix, index=tf_names_list, columns=tf_names_list, dtype='float32')
    df.to_csv(matrix_name+".csv")

def main():
    tf_peak_number = sys.argv[1]
    tf_peak_number_dict = get_tf_index_peaks(tf_peak_number)
    pair_overlap_dict = get_tf_pair_overlap()

    matrix_name = tf_peak_number.replace(".txt", ".matrix")
    compute_So_matrix(tf_peak_number_dict, pair_overlap_dict, matrix_name)
    

if __name__=="__main__":
    main()
