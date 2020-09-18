#!/usr/bin/python
from __future__ import print_function
import sys
import re

def count_origin_peak_number(cluster_sort_name):
    peak_set = set()
    with open(cluster_sort_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            new_peak = "{}:{}:{}".format(line_split[0].replace("_", ":"), line_split[1], line_split[2])
            peak_set.add(new_peak)

    with open("{}.origin_peak_number". format(cluster_sort_name), "w") as fout:
        output = "{}\n".format(len(peak_set))
        fout.write(output)
        

def main():
    cluster_sort_name = sys.argv[1]
    count_origin_peak_number(cluster_sort_name)

if __name__=="__main__":
    main()
