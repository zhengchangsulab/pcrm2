#!/usr/bin/python
from __future__ import print_function
import glob
import sys
import numpy as np
import pandas as pd

def get_all_motifs():
    motif_list = glob.glob("*_motif/*.motif")
    return motif_list

def extract_infomation_content(dataset_name, motif_list):

    ic_list = []
    motif_name_list = []
    for motif in motif_list:
        motif_name = motif.split("/")[1].split(".")[0]
        motif_name_list.append(motif_name)

        with open(motif) as fin:
            for line in fin:
                if line.startswith("I"):
                    line_split = line.strip().split("\t")
                    #ic = sum([float(i) for i in line_split[1:]])
                    #ic_list.append(ic)
                    ic = np.float32(sum([float(i) for i in line_split[1:]]))
                    ic_list.append(ic)
                    break


    ic = np.asarray(ic_list, dtype='float32')
    df = pd.DataFrame(data=ic, index=motif_name_list, columns=['ic'])
    file_name = dataset_name + "_IC.csv"
    df.to_csv(file_name)

def get_all_memes():
    meme_list = glob.glob("*_motif/*.meme")
    return meme_list


def extract_score(dataset_name, meme_list):
    score_list = []
    motif_list = []

    for meme in meme_list:
        motif = meme.split("/")[1].split(".")[0]
        motif_list.append(motif)
        with open(meme) as fin:
            for line in fin:
                if line.startswith("letter"):
                    line_split = line.strip().split(" ")
                    score = np.float32(line_split[-1])
                    score_list.append(score)
                    break

    score = np.asarray(score_list, dtype='float32')
    df = pd.DataFrame(data=score, index=motif_list, columns=['score'])
    file_name = dataset_name + "_Score.csv"
    df.to_csv(file_name)
    


def main():
    dataset_name = sys.argv[1]
    motif_list = get_all_motifs()
    extract_infomation_content(dataset_name, motif_list)

    meme_list = get_all_memes()
    extract_score(dataset_name, meme_list)


if __name__=="__main__":
    main()
