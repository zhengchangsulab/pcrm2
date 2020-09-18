#!/usr/bin/python
from __future__ import print_function
import sys
import cPickle as pickle

def build_binding_sites_to_original_peak_map(cluster_name):
    binding_sites_original_peak_dict = {}

    with open(cluster_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            key = line_split[0]+":"+line_split[1]+"-"+line_split[2]
            value = line_split[3]
            binding_sites_original_peak_dict[key] = value

    return binding_sites_original_peak_dict

def convert_to_original(cluster_umotif_sites_name, mapping_file):

    cluster_site_name = cluster_umotif_sites_name.split(".")[0]+":"

    fout = open(cluster_umotif_sites_name+".origin", "w")

    with open(cluster_umotif_sites_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")


            original_peak = [mapping_file[":".join(i.split(":")[1:])] for i in line_split[3].split(",")]
            new_origianl_peak_peak = ",".join(original_peak)

            new_line = "\t".join(line_split[:3])+"\t" + new_origianl_peak_peak+"\n"
            fout.write(new_line)
    fout.close()


def main():
    cluster_name = sys.argv[1]
    cluster_umotif_sites_name = sys.argv[2]

    mapping_file = build_binding_sites_to_original_peak_map(cluster_name)

    convert_to_original(cluster_umotif_sites_name, mapping_file)

if __name__=="__main__":
    main()
