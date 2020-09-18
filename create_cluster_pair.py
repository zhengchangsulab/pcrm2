#!/usr/bin/python
from __future__ import print_function
import glob

def main():
    cluster_peak_list = glob.glob("cluster_*.30.8.8_0.sites.bed.origin.origin_peak")
    cluster_name_list = sorted([i.replace(".30.8.8_0.sites.bed.origin.origin_peak", "") for i in cluster_peak_list])
    for i in range(len(cluster_name_list)-1):
        cluster_name = cluster_name_list[i]

        with open(cluster_name+".pair", "w") as fin:
            for j in range(i+1, len(cluster_name_list)):
                pair_name = cluster_name_list[j]
                output = pair_name+"\n"
                fin.write(output)

if __name__=="__main__":
    main()
