#!/usr/bin/python
from __future__ import print_function
import sys
from collections import OrderedDict
import re

def convert_format(gt_2_name):

    regex = re.compile(r"_[0-9]+:", re.IGNORECASE)

    origin_peak_site_dict = OrderedDict()
    with open(gt_2_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            binding_site = line_split[0]+":"+line_split[1]+"-"+line_split[2]
            
            origin_peaks_list = [re.sub(regex,"_", origin_peak) for origin_peak in line_split[3].split(",")]
            for origin_peak in origin_peaks_list:
                try:
                    origin_peak_site_dict[origin_peak].append(binding_site)
                except:
                    origin_peak_site_dict[origin_peak] = [binding_site]
                
    
    delimiter=re.compile(r":|-")
    with open(gt_2_name+".origin_bed", "w") as fout:
        for origin_peak_key in sorted(origin_peak_site_dict.keys()):
            origin_peak_key_split = delimiter.split(origin_peak_key)
            peak = "\t".join(origin_peak_key_split)
            binding_site_list = "|".join(list(set(origin_peak_site_dict[origin_peak_key])))
            
            new_line = peak + "\t" + binding_site_list +"\n"
            fout.write(new_line)


def main():
    gt_2_name = sys.argv[1]
    convert_format(gt_2_name)

if __name__=="__main__":
    main()
