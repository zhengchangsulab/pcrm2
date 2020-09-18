#!/usr/bin/python
from __future__ import print_function
import sys


def build_peak_tfbs_dict(overlap_name, flag):
    
    peak_tfbs_dict = {}
    
    with open(overlap_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            peak = ":".join(line_split[:3])
            tfbs_list = [tfbs+":"+str(flag) for tfbs in line_split[3].split(",")]
            peak_tfbs_dict[peak] = tfbs_list

    return peak_tfbs_dict





def paser_tfbs_info(tfbs):
    start, end, flag = tfbs.split(":")
    return int(start), int(end), int(flag)

def compute_closest(merge_tfbs_list_sort):
    closest_dist = float("inf")

    pre_tfbs = merge_tfbs_list_sort[0]
    pre_start, pre_end, pre_flag = paser_tfbs_info(pre_tfbs)
    
    for i in range(1, len(merge_tfbs_list_sort)):
        curr_tfbs = merge_tfbs_list_sort[i]
        curr_start, curr_end, curr_flag = paser_tfbs_info(curr_tfbs)

        if curr_flag != pre_flag:
            curr_dist = curr_start - pre_end
            if curr_dist < closest_dist:
                closest_dist = curr_dist
            pre_flag = curr_flag
        else:
            pre_start = curr_start
            pre_end = curr_end

    return closest_dist
    
        


def get_closest_distance(overlap_1_2, peak_tfbs_dict_1, peak_tfbs_dict_2):
    fout = open(overlap_1_2+".dist_v2", "w")
    for key in peak_tfbs_dict_1.keys():
        tfbs_list_1 = peak_tfbs_dict_1[key]
        tfbs_list_2 = peak_tfbs_dict_2[key]
        
        merge_tfbs_list = tfbs_list_1 + tfbs_list_2
        merge_tfbs_list_sort = sorted(merge_tfbs_list, key = lambda x:(int(x.split(":")[0]), int(x.split(":")[1]), int(x.split(":")[2])))
        closest_dist = compute_closest(merge_tfbs_list_sort)
        tfbs_list_1 = [":".join(i.split(":")[:2]) for i in tfbs_list_1]
        output = key.replace(":", "\t") + "\t" + ",".join(tfbs_list_1)+"\t"+str(closest_dist)+"\n"
        fout.write(output)
        
    fout.close()


def main():
    overlap_1_2 = sys.argv[1]
    cluster_name = overlap_1_2.replace(".overlap", "").split("-")[0]
    pair_cluster_name = overlap_1_2.replace(".overlap", "").split("-")[1]

    overlap_2_1 = "../"+pair_cluster_name+"/"+pair_cluster_name +"-" +cluster_name + ".overlap"

    peak_tfbs_dict_1 = build_peak_tfbs_dict(overlap_1_2, 1)
    peak_tfbs_dict_2 = build_peak_tfbs_dict(overlap_2_1, 2)

    get_closest_distance(overlap_1_2, peak_tfbs_dict_1, peak_tfbs_dict_2)

if __name__=="__main__":
    main()
