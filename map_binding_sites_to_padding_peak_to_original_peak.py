#!/usr/bin/python
from __future__ import print_function
import sys
import pickle as pickle
from collections import OrderedDict

def build_binding_sites_to_original_padding_peak_map(origin_padding_name):
    binding_sites_original_padding_peak_dict = OrderedDict()

    with open(origin_padding_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            # padding peak name
            key = line_split[0]+":"+line_split[1]+":"+line_split[2]
            # origin peak name
            value = line_split[0]+":"+line_split[3]
            binding_sites_original_padding_peak_dict[key] = value

    return binding_sites_original_padding_peak_dict


def build_origin_padding_to_origin_peak_map(origin_name):
    origin_padding_to_origin_peak_dict = OrderedDict()

    with open(origin_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            key = line_split[0]+":"+line_split[1]+":"+line_split[2]
            value = line_split[3]
            origin_padding_to_origin_peak_dict[key] = value

    return origin_padding_to_origin_peak_dict



def convert_to_original(cluster_umotif_sites_name, binding_sites_original_padding_peak_dict, origin_padding_to_origin_peak_dict):


    fout = open(cluster_umotif_sites_name+".origin", "w")

    with open(cluster_umotif_sites_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            padding_peak_info = line_split[3].split(":")
            padding_peak = padding_peak_info[1]+":"+padding_peak_info[2].replace("-", ":")
            origin_peak = origin_padding_to_origin_peak_dict[binding_sites_original_padding_peak_dict[padding_peak]]
            output = "\t".join(line_split[:3])+"\t"+origin_peak+"\n"
            fout.write(output)

    fout.close()


def main():
    origin_padding_name = sys.argv[1]
    origin_name = sys.argv[2]
    cluster_umotif_sites_name = sys.argv[3]

    mapping_padding_dict = build_binding_sites_to_original_padding_peak_map(origin_padding_name)
    origin_padding_to_origin_peak_dict = build_origin_padding_to_origin_peak_map(origin_name)

    convert_to_original(cluster_umotif_sites_name, mapping_padding_dict, origin_padding_to_origin_peak_dict)

if __name__=="__main__":
    main()
