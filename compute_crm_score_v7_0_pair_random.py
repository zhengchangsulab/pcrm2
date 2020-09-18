#!/usr/bin/python
from __future__ import print_function
import cPickle as pickle
import json
import re
import ujson
import simplejson
import time
from collections import Counter
import sys
import numpy as np

def build_network_dict():
    network_dict = {}

    nodes_set = set()

    network_name="/nobackup/zcsu_research/npy/UMOTIF_BINDING_SITES_PEAK_FOLDER_MOUSE_1000/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/Umotif_Interaction_Score_gt_2.txt.random"

    with open(network_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            node_1 = line_split[0].split("_")[1]
            node_2 = line_split[1].split("_")[1]
            edge_f = node_1+"-"+node_2
            edge_r = node_2+"-"+node_1

            weight = float(line_split[2])

            network_dict[edge_f] = weight
            network_dict[edge_r] = weight

            nodes_set.add(node_1)
            nodes_set.add(node_2)


    for node in nodes_set:
        edge = node+"-"+node
        network_dict[edge] = 1
        
    return network_dict
            
    
def paser_binding_score(binding_score):

    binding_score_dict = {}

    with open(binding_score) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            binding_name = line_split[0]
            binding_score = line_split[1]

            binding_score_dict[binding_name] = float(binding_score) #[float(binding_score), 0][float(binding_score) < 0]

    return binding_score_dict


def paser_umotif_score():

    umotif_cutoff_dict = {}
    with open("umotif_score_stats.txt") as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            umotif = line_split[0]
            cutoff_score = [float(i) for i in line_split[1].split("|")]
            umotif_cutoff_dict[umotif] = cutoff_score
            
    return umotif_cutoff_dict

def keep_positive_binding_site(binding_sites_list, binding_score_dict, umotif_cutoff_dict, cutoff_type):

    positive_binding_sites_list = []
    for binding_site in binding_sites_list:

        binding_score = binding_score_dict[binding_site]
        binding_umotif = binding_site.split("|")[0]

        if cutoff_type == "MEAN":
            cutoff_index = 0
        elif cutoff_type == "SIGMA_1":
            cutoff_index = 3
        elif cutoff_type == "SIGMA_2":
            cutoff_index = 4

        elif cutoff_type == "SIGMA_3":
            cutoff_index = 5
        elif cutoff_type == "SIGMA_4":
            cutoff_index = 6
        else:
            print("set cutoff_index in {} {} {}".format("MEAN", "SIGMA_1", "SIGMA_2", "SIGMA_3", "SIGMA_4"))
            
        cutoff_value = umotif_cutoff_dict[binding_umotif][cutoff_index]

        binding_score = binding_score_dict[binding_site]

        if binding_score > 0:
            positive_binding_sites_list.append("{}+{}+{}".format(binding_site, str(binding_score), cutoff_value))

    return positive_binding_sites_list


def compute_crm_score(binding_sites_list, network_dict, binding_score_dict, umotif_cutoff_dict, cutoff_type):
    positive_binding_sites_list = keep_positive_binding_site(binding_sites_list, binding_score_dict, umotif_cutoff_dict, cutoff_type)
    
    total_score = 0

    if len(positive_binding_sites_list) > 1:
        for i in xrange(len(positive_binding_sites_list) - 1):
            for j in xrange(i+1, len(positive_binding_sites_list)):
                node_i = positive_binding_sites_list[i].split("+")[0]
                node_j = positive_binding_sites_list[j].split("+")[0]
                
                node_index_i = node_i.split("|")[0]
                node_index_j = node_j.split("|")[0]
                
                
                edge = node_index_i + "-" + node_index_j
                try:
                    weight_i_j = network_dict[edge]
                    
                except:
                    weight_i_j = 0
                    
                sum_binding_site_score = binding_score_dict[node_i] + binding_score_dict[node_j]
                sub_score = weight_i_j * sum_binding_site_score
                    
                total_score += sub_score
    else:
        pass
                    
    if len(positive_binding_sites_list) >= 2:
        total_score = (total_score * 2)/(len(positive_binding_sites_list) - 1) #total_score / np.log2(len(positive_binding_sites_list) * (len(positive_binding_sites_list) - 1))
    else:
        total_score = 0

    return total_score, positive_binding_sites_list
            
        
def main():
    binding_score_name = sys.argv[1]
    crm_name = sys.argv[2]
    cutoff_type = sys.argv[3]

    umotif_cutoff_dict = paser_umotif_score()
    
    network_dict = build_network_dict()
    binding_score_dict = paser_binding_score(binding_score_name)

    with open(crm_name+".pos_site.keep_pos_site.0.n-1.score", "w") as fout:
        with open(crm_name) as fin:
            for line in fin:
                line_split = line.strip().split("\t")
                binding_sites_list = line_split[3].split(",")
                crm_score, positive_binding_sites_list = compute_crm_score(binding_sites_list, network_dict, binding_score_dict, umotif_cutoff_dict, cutoff_type)
           

                output = "\t".join(line_split[:3]) +"\t"+ ",".join(positive_binding_sites_list) + "\t" + str(crm_score) + "\n"
                fout.write(output)
            

if __name__=="__main__":
    main()
