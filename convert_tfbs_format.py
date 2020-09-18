#!/usr/bin/python

from __future__ import print_function
import sys


def convert_tfbs(overlap_dist):
    cluster_1_index = overlap_dist.split("-")[0].replace("cluster_", "")
    with open("{}.tfbs".format(overlap_dist), "w") as fout:
        with open(overlap_dist) as fin:
            for line in fin:
                line_split = line.strip().split("\t")
                dataset = line_split[0].split("_")[0]
                chrom = line_split[0].split("_")[1]
                # remove repeat tfbs
                tfbs_list = set(line_split[3].split(","))
                for tfbs in tfbs_list:
                    start, end = tfbs.split(":")
                    output = "{}\t{}\t{}\t{}|{}|{}-{}\n".format(chrom, start, end, cluster_1_index, dataset, start, end)
                    fout.write(output)
                    

def main():
    overlap_dist = sys.argv[1]
    convert_tfbs(overlap_dist)


if __name__=="__main__":
    main()
