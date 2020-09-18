#!/usr/bin/python

from __future__ import print_function
import sys
import simplejson
import os
import numpy as np


def load_simplejson(cluster_name):
    with open(cluster_name, "rb") as fp:
        data = simplejson.load(fp)
    return data

def paser_cluster_pair_list(cluster_pair_name):
    pair_list = []
    with open(cluster_pair_name) as fin:
        for line in fin:
            pair = line.strip()
            pair_list.append(pair)

    return pair_list


def compute_score(cluster_1, cluster_2, overlap_info_name):
    dist_dataset_dict = {}
    with open(overlap_info_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            dataset = line_split[0].split("_")[0]
            dist = int(line_split[4])
            dist = [dist, 150][dist<150]
            try:
                dist_dataset_dict[dataset].append(dist)
            except:
                dist_dataset_dict[dataset] = [dist]

    dataset_number = len(dist_dataset_dict.keys())

    total = 0
    for key in dist_dataset_dict.keys():
        cluster_1_total_peak_number = cluster_1[key]
        cluster_2_total_peak_number = cluster_2[key]
        overlap_dist_array = np.array(dist_dataset_dict[key])
        weight_overlap_dist_total = np.sum(float(150)/overlap_dist_array)
        
        cluster_1_total_peak = weight_overlap_dist_total / cluster_1_total_peak_number
        cluster_2_total_peak = weight_overlap_dist_total / cluster_2_total_peak_number

        average_cluster_1_2_subtotal = (cluster_1_total_peak + cluster_2_total_peak)/2
        total += average_cluster_1_2_subtotal

    

    final_score = total/dataset_number
    return final_score
        
        
def compute_score_for_cluster(cluster_name, cluster_pair_list):
    cluster_name_dataset = "{}.30.8.8_0.sites.bed.origin.origin_peak.dataset_number.simplejson".format(cluster_name)
    cluster_name_peak_dict = load_simplejson(cluster_name_dataset)

    fout = open("{}.score".format(cluster_name), "w")
    for pair in cluster_pair_list:
        pair_name = "{}.30.8.8_0.sites.bed.origin.origin_peak.dataset_number.simplejson".format(pair)
        pair_peak_dict = load_simplejson(pair_name)
        dist_info_name = "{}/{}-{}.overlap.dist.c".format(cluster_name,cluster_name,pair)
        
        if os.path.getsize(dist_info_name):
            final_score = compute_score(cluster_name_peak_dict, pair_peak_dict, dist_info_name)
            output = "{}\t{}\t{}\n".format(cluster_name, pair, str(final_score))
            fout.write(output)
        
def main():
    cluster_pair_name = sys.argv[1]
    cluster_name = cluster_pair_name.replace(".pair", "")
    cluster_pair_list =  paser_cluster_pair_list(cluster_pair_name)
    compute_score_for_cluster(cluster_name, cluster_pair_list)
    
    
    
if __name__=="__main__":
    main()
