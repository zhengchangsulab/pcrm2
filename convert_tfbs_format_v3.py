#!/usr/bin/python

from __future__ import print_function
import sys


def convert_tfbs(overlap_dist):
    cluster_1_index = overlap_dist.split("-")[0].replace("cluster_", "")

    tfbs_dict = {}

    with open(overlap_dist) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            dataset = line_split[0].split("_")[0]
            chrom = line_split[0].split("_")[-1]
            # remove repeat tfbs
        
            tfbs_list = set(line_split[3].split(","))
            
            for tfbs in tfbs_list:
                tfbs_chrom="{}:{}".format(chrom, tfbs)
                try:
                    tfbs_dict[tfbs_chrom].append(dataset)
                except:
                    tfbs_dict[tfbs_chrom] = [dataset]
                    

    """
    with open("{}.tfbs.dataset_info".format(overlap_dist), "w") as fout:
        for tfbs in tfbs_dict.keys():
            output = "{x[0]}\t{x[1]}\t{x[2]}\t{index}|{dataset}|{tfbs}\n".format(x=tfbs.split(":"), index=cluster_1_index, dataset="+".join(list(set(tfbs_dict[tfbs]))),tfbs=":".join(tfbs.split(":")[1:]))
            fout.write(output)
    """

    with open("{}.tfbs".format(overlap_dist), "w") as fout:
        for tfbs in tfbs_dict.keys():
            output = "{x[0]}\t{x[1]}\t{x[2]}\t{index}|{tfbs}\n".format(x=tfbs.split(":"), index=cluster_1_index,tfbs=":".join(tfbs.split(":")[1:]))
            fout.write(output)
            
                    

def main():
    overlap_dist = sys.argv[1]
    convert_tfbs(overlap_dist)


if __name__=="__main__":
    main()
