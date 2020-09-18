#!/usr/bin/python
from __future__ import print_function
import sys
import re
from collections import OrderedDict

def filter_peaks(origin_file):
    regex = re.compile(r"_[0-9]+:", re.IGNORECASE)

    all_peak_list = []
    with open(origin_file) as fin:
        for line in fin:

            # remove motif index
            new_line = re.sub(regex, "_", line)
            new_line_split = new_line.strip().split("\t")
            #remove repeat peak in same dataset
            origin_peaks = sorted(list(set(new_line_split[3].split(","))))
            # select binding sites occur in at least 2 datasets
            if len(origin_peaks) > 1:
                all_peak_list += origin_peaks

    dataset_peaks_umotif = sorted(list(set(all_peak_list)))
    return dataset_peaks_umotif



def create_dataset_peaks_dict(dataset_peaks_umotif):
    dataset_peaks_dict = OrderedDict()
    for dataset_peaks in dataset_peaks_umotif:
        dataset_peaks_split = dataset_peaks.split("_")
        
        dataset_name = dataset_peaks_split[0]
        chrom, start, end = re.split(':|-', dataset_peaks_split[1])
        peak_dict = OrderedDict()
        peak_dict[chrom] = [int(start), int(end)]

        try:
            dataset_peaks_dict[dataset_name].append(peak_dict)
        except:
            dataset_peaks_dict[dataset_name] = [peak_dict]
    return dataset_peaks_dict


def main():
    origin_file_1 = sys.argv[1]
    #origin_file_2 = sys.argv[2]
    dataset_peaks_umotif = filter_peaks(origin_file_1)
    d_1 = create_dataset_peaks_dict(dataset_peaks_umotif)
    print(d_1.keys())

    #dataset_peaks_umotif = filter_peaks(origin_file_2)
    #d_2 = create_dataset_peaks_dict(dataset_peaks_umotif)

    

if __name__=="__main__":
    main()
