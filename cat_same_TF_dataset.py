#!/usr/bin/python
from __future__ import print_function
import sys
from collections import OrderedDict
import os
import shutil
import subprocess

def TF_Unique_dict(file_name):
    TF_dataset_dict = OrderedDict()

    with open(file_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            key = ":".join(line_split[3:7])
            dataset = line_split[-1].split("_")[0]
            if key not in TF_dataset_dict.keys():
                TF_dataset_dict[key] = [dataset]
            else:
                
                TF_dataset_dict[key].append(dataset)
    return TF_dataset_dict

def cat_same_TF_files(TF_dataset_dict):
    pool_folder = "Pool_Folder"
    if not os.path.isdir(pool_folder):
        os.mkdir(pool_folder)
    else:
        cmd = "rm -rf "+pool_folder
        subprocess.call(cmd, shell=True)
        
    for key in TF_dataset_dict:
        dataset_index_list = TF_dataset_dict[key]
        if len(dataset_index_list) == 1:
            file_name = dataset_index_list[0]+"_sort_peaks.narrowPeak.filter_score_chr.bed"
            shutil.copy(file_name, pool_folder)
            
        else:
            same_TF_file_list = [i+"_sort_peaks.narrowPeak.filter_score_chr.bed" for i in dataset_index_list]
            merge_name = "_".join(dataset_index_list[:2])+"_etd__sort_peaks.narrowPeak.filter_score_chr.bed"
            
            cat_cmd = "cat "+" ".join(same_TF_file_list) + " >" + merge_name+".unsort"
            subprocess.call(cat_cmd, shell=True)
            sort_cmd = "sort -k1,1 -k2,2n " + merge_name+".unsort" + ">" + merge_name+".unmerge"
            subprocess.call(sort_cmd, shell=True)
            merge_cmd = "bedtools merge -i "+ merge_name+".unmerge" + ">" + merge_name
            subprocess.call(merge_cmd, shell=True)
            shutil.move(merge_name, pool_folder)
            os.remove(merge_name+".unsort")
            os.remove(merge_name+".unmerge")


def cat_same_TF_with_none_files(TF_dataset_dict):
    pool_folder = "Pool_None_Folder"

    if not os.path.isdir(pool_folder):
        os.mkdir(pool_folder)
    else:
        cmd = "rm -rf "+pool_folder
        subprocess.call(cmd, shell=True)
        os.mkdir(pool_folder)

    for key in TF_dataset_dict:
        dataset_index_list = TF_dataset_dict[key]
        if len(dataset_index_list) == 1:
            file_name = dataset_index_list[0]+"_sort_peaks.narrowPeak.filter_score_chr.bed"
            shutil.copy(file_name, pool_folder)
            
        else:
            if "None:None:None" in key:
                for file_name_index in TF_dataset_dict[key]:
                    file_name = file_name_index+"_sort_peaks.narrowPeak.filter_score_chr.bed"
                    shutil.copy(file_name, pool_folder)
            else:
                same_TF_file_list = [i+"_sort_peaks.narrowPeak.filter_score_chr.bed" for i in dataset_index_list]
                merge_name = "_".join(dataset_index_list[:2])+"_etd__sort_peaks.narrowPeak.filter_score_chr.bed"
                
                cat_cmd = "cat "+" ".join(same_TF_file_list) + " >" + merge_name+".unsort"
                subprocess.call(cat_cmd, shell=True)
                sort_cmd = "sort -k1,1 -k2,2n " + merge_name+".unsort" + ">" + merge_name+".unmerge"
                subprocess.call(sort_cmd, shell=True)
                merge_cmd = "bedtools merge -i "+ merge_name+".unmerge" + ">" + merge_name
                subprocess.call(merge_cmd, shell=True)
                shutil.move(merge_name, pool_folder)
                os.remove(merge_name+".unsort")
                os.remove(merge_name+".unmerge")


def main():
    file_name = sys.argv[1]
    TF_dataset_dict = TF_Unique_dict(file_name)
    cat_same_TF_with_none_files(TF_dataset_dict)


if __name__=="__main__":
    main()
