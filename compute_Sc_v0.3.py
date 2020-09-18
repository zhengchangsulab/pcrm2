#!/usr/bin/python
from __future__ import print_function
import sys
import glob
from collections import Counter, OrderedDict
import cProfile    
from itertools import combinations 

def get_peak_for_tf_set(index):
    motif_pattern = index+"_motif/*.sites"
    motifs = glob.glob(motif_pattern)
    tf_peaks_dict = OrderedDict()
    for motif in motifs:
        motif_index = motif.split("/")[1].replace(".sites", "")
        with open(motif) as fin:
            header = fin.readline()
            motif_sites_set = set([line.strip().split("\t")[0] for line in fin])
        
        tf_peaks_dict[motif_index] = motif_sites_set
    return tf_peaks_dict


def get_peak_for_tf_list(index):
    motif_pattern = index+"_motif/*.sites"
    motifs = glob.glob(motif_pattern)
    tf_peaks_dict = OrderedDict()
    for motif in motifs:
        motif_index = motif.split("/")[1].replace(".sites", "")
        with open(motif) as fin:
            header = fin.readline()
            motif_sites_list = [line.strip().split("\t")[0] for line in fin]
        
        tf_peaks_dict[motif_index] = motif_sites_list
    return tf_peaks_dict
    

    
def compute_Sc(tf_peaks_dict,index):

    Sc_name = "Sc_Score_" + index + ".u.txt"
    motifs = tf_peaks_dict.keys()
    with open(Sc_name, "w") as fout:
        for motif_1, motif_2 in combinations(motifs, 2):
            intersect_1_2_number = float(len(tf_peaks_dict[motif_1] & tf_peaks_dict[motif_2]))
            max_1_2_number = float(max(len(tf_peaks_dict[motif_1]), len(tf_peaks_dict[motif_2])))
            Sc = intersect_1_2_number/max_1_2_number
            new_line = motif_1+"\t"+motif_2+"\t"+str(Sc)+"\n"
            fout.write(new_line)

def compute_Sc_multiple_occurance(tf_peaks_dict, index):
    Sc_name = "Sc_Score_" + index + ".m.txt"

    motifs = tf_peaks_dict.keys()

    with open(Sc_name, "w") as fout:
        for motif_1, motif_2 in combinations(motifs, 2):
            motif_1_counter = Counter(tf_peaks_dict[motif_1])
            motif_1_peak_number = len(tf_peaks_dict[motif_1])

            motif_2_counter = Counter(tf_peaks_dict[motif_2])
            motif_2_peak_number = len(tf_peaks_dict[motif_2])

            overlap = 0
            for peak in motif_1_counter.keys():
                if peak in motif_2_counter.keys():
                    overlap_1_2 = [motif_1_counter[peak], motif_2_counter[peak]][motif_1_counter[peak]>=motif_2_counter[peak]]
                    overlap += overlap_1_2
            
                
            max_peak_number = float(max(motif_1_peak_number, motif_2_peak_number))
            try:
                Sc = float(overlap)/max_peak_number
            except:
                Sc = 0.0
                
            new_line = motif_1+"\t"+motif_2+"\t"+str(Sc)+"\n"
            fout.write(new_line)
            
def main():
    index = sys.argv[1]
    tf_peaks_dict_set = get_peak_for_tf_set(index)
    compute_Sc(tf_peaks_dict_set, index)

    #tf_peaks_dict_list = get_peak_for_tf_list(index)
    #compute_Sc_multiple_occurance(tf_peaks_dict_list, index)

if __name__=="__main__":
    main()
