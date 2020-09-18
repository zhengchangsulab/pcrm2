#!/usr/bin/python
from __future__ import print_function
import sys

def get_umotif_peak(umotif_clean):
    peaks_list = []
    with open(umotif_clean) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            peaks = line_split[3].split(",")
            for peak in peaks:
                peak_name = ":".join(peak.split(":")[1:])
                peaks_list.append(peak_name)

    return peaks_list


def get_cluster_peak(cluster_clean):
    peaks_list = []
    with open(cluster_clean) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            peak_name = line_split[0]+":"+line_split[1]+"-"+line_split[2]
            peaks_list.append(peak_name)

    return peaks_list



def compute_ratio(umotif_peak_set, cluster_peak_set):
    return float(len(umotif_peak_set))/float(len(cluster_peak_set))
            
    
def main():
    umotif_clean = sys.argv[1]
    cluster_clean = sys.argv[2]
    umotif_peak_set = get_umotif_peak(umotif_clean)
    cluster_peak_set = get_cluster_peak(cluster_clean)
    ratio = compute_ratio(umotif_peak_set, cluster_peak_set)

    with open(umotif_clean+".ratio", "w") as fout:
        fout.write(umotif_clean+"\t"+str(ratio)+"\n")

if __name__=="__main__":
    main()
