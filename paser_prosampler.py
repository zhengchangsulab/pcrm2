#!/usr/bin/python
from __future__ import print_function
import sys
import os
import glob

def paser_site(site_file_name):
    """
    inputs: site file
    output: each file contain sites for each motif
    """
    dataset_name = site_file_name.split("_")[0]
    motif_index = -1

    if not os.path.isdir(dataset_name+"_motif"):
        os.mkdir(dataset_name+"_motif")

    with open(site_file_name) as fin:
        for line in fin:
            if line.startswith("MOTIF"):
                motif_index += 1
                content = line.strip().split(" ")
                motif_consensus = content[1]
                motif_out_name = os.path.join(dataset_name + "_motif",  dataset_name + "_" + str(motif_index) + ".sites")

                fout = open(motif_out_name, "w")
                header = dataset_name + "." + str(motif_index) + "." +motif_consensus + ".motif"
                fout.write(header+"\n")

            elif line.startswith("chr"):
                fout.write(line)
            else:
                next


def paser_meme(meme_file_name):
    """
    inputs: site file
    output: each file contain sites for each motif
    """
    dataset_name = meme_file_name.split("_")[0]
    motif_index = -1

    if not os.path.isdir(dataset_name+"_motif"):
        os.mkdir(dataset_name+"_motif")

    with open(meme_file_name) as fin:
        for line in fin:
            if line.startswith("MOTIF"):
                motif_index += 1
                content = line.strip().split(" ")
                motif_consensus = content[1]
                motif_out_name = os.path.join(dataset_name + "_motif",  dataset_name + "_" + str(motif_index) + ".psm")

                fout = open(motif_out_name, "w")
                header = dataset_name + "." + str(motif_index) + "." +motif_consensus + ".motif"
                fout.write(header+"\n")

            elif line.startswith(("0.", "1.")):
                fout.write(line)
            else:
                next


def paser_meme_out_meme(meme_file_name):
    """
    inputs: site file
    output: each file contain sites for each motif
    """
    dataset_name = meme_file_name.split("_")[0]
    motif_index = -1

    if not os.path.isdir(dataset_name+"_motif"):
        os.mkdir(dataset_name+"_motif")

    with open(meme_file_name) as fin:
        for line in fin:
            if line.startswith("letter-probability"):
                motif_index += 1
                #content = line.strip().split(" ")
                #motif_consensus = content[1]
                motif_out_name = os.path.join(dataset_name + "_motif",  dataset_name + "_" + str(motif_index) + ".meme")

                fout = open(motif_out_name, "w")
                #header = dataset_name + "." + str(motif_index) + "." +motif_consensus + ".motif"
                fout.write(line)

            elif line.startswith(("0.", "1.")):
                fout.write(line)
            else:
                next


def paser_motif(motif_file_name):
    """
    inputs: spic file
    output: prf, information content, psm for each motif
    """
    dataset_name = motif_file_name.split("_")[0]
    motif_index = -1
    print(dataset_name)
    if not os.path.isdir(dataset_name+"_motif"):
        os.mkdir(dataset_name+"_motif")

        
    with open(motif_file_name) as fin:
        for line in fin:
            if line.startswith("MOTIF"):
                motif_index += 1
                content = line.strip().split(" ")
                motif_consensus = content[1]
                motif_out_name = os.path.join(dataset_name+"_motif", dataset_name + "_" + str(motif_index) + ".motif")
                fout = open(motif_out_name, "w")
                header = dataset_name + "." + str(motif_index) +"." + motif_consensus + ".motif"
                fout.write(header+"\n")

            elif line.startswith(("A\t", "G\t", "C\t", "T\t", "I\t", "a\t", "g\t", "c\t", "t\t")):
                fout.write(line)
            else:
                next


def get_file_list(dataset):
    with open(dataset) as fin:
        file_list = [line.strip() for line in fin.readlines()]
    return file_list

    
def main():
    dataset = sys.argv[1]
    file_names = get_file_list(dataset)

    for file_name in file_names: 
        motif_file_name = file_name.replace(".meme", ".spic") #file_name + ".prosampler.txt.spic"
        site_file_name = file_name.replace(".meme", ".site") #file_name + ".prosampler.txt.site"
        meme_file_name = file_name #file_name + ".prosampler.txt.meme"

        paser_motif(motif_file_name)
        paser_site(site_file_name)
        paser_meme_out_meme(meme_file_name)

if __name__=="__main__":
    main()
