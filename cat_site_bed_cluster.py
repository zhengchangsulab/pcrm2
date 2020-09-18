#!/usr/bin/python
from __future__ import print_function
import sys
import glob
import os


def get_cluster_index():
    abs_path="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_1500/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_SITES_GT_0.7_FOLDER/SITES_BED"
    motifs_list_meme = glob.glob("*.meme.png")
    motif_sites_list = [os.path.join(abs_path, motif_logo.replace(".meme.png", ".sites")+".bed") for motif_logo in motifs_list_meme]
    return motif_sites_list


def cat_bed_files(cluster_name):

    cluster_bed_name = cluster_name+".bed"

    os.chdir(cluster_name)

    with open(cluster_bed_name, "w") as fout:
        motif_sites_list = get_cluster_index()
        for motif_sites in motif_sites_list:
            with open(motif_sites) as fin:
                content = fin.readlines()
                fout.writelines(content)
                
    os.chdir("../")

def main():
    cluster_name = sys.argv[1]
    cat_bed_files(cluster_name)


if __name__=="__main__":
    main()
