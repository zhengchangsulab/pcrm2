#!/usr/bin/python
from __future__ import print_function
import sys
import re
import os

def convert_origin_to_tfbs(origin_name):
    regex = re.compile(r"_[0-9]+:", re.IGNORECASE)
    origin_peak_tfbs_dict = {}
    with open(origin_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            tfbs= line_split[1]+":"+line_split[2]
            origin_peaks = line_split[3].split(",")
            for origin_peak in origin_peaks:
                origin_peak = re.sub(regex,"_", origin_peak)
                try:
                    origin_peak_tfbs_dict[origin_peak].append(tfbs)
                except:
                    origin_peak_tfbs_dict[origin_peak] = [tfbs]
    return origin_peak_tfbs_dict


def write_output_origin_peak_tfbs(origin_name, origin_peak_tfbs_dict, dataset):
    regex = re.compile(r':|-', re.IGNORECASE)
    output_folder="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"+dataset+"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/"
    os.makedirs(output_folder, exist_ok=True)
    output_name = "/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"+dataset+"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/"+origin_name+".origin_peak"
    

    with open(output_name, "w") as fout:
        for key in origin_peak_tfbs_dict.keys():
            # remove repeat tfbs
            tfbs_list = list(set(origin_peak_tfbs_dict[key]))
            tfbs_list_sort = sorted(tfbs_list, key = lambda x:(int(x.split(":")[0]), int(x.split(":")[1])))
            key_split = re.split(regex, key)
            start = key_split[-2]
            end = key_split[-1]
            chrom = "-".join(key_split[:-2])
            
            output = "{}\t{}\t{}".format(chrom, start, end) + "\t" + ",".join(tfbs_list_sort)+"\n"
            fout.write(output)

def main():
    origin_name = sys.argv[1]
    dataset = sys.argv[2]
    origin_peak_tfbs_dict = convert_origin_to_tfbs(origin_name)
    write_output_origin_peak_tfbs(origin_name, origin_peak_tfbs_dict, dataset)

if __name__=="__main__":
    main()
