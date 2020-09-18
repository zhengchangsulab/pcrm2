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
    dataset_name = site_file_name.replace(".site", "")
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
    dataset_name = meme_file_name.replace(".meme", "")
    motif_index = -1

    if not os.path.isdir(dataset_name+"_motif"):
        os.mkdir(dataset_name+"_motif")

    with open(meme_file_name) as fin:

        header_1_holder = []
        i = 0
        while i < 15:
            line = fin.readline()
            if line.startswith(("MEME", "ALPH", "Back", "A")):
                header_1_holder.append(line)
            i += 1

        for line in fin:
            if line.startswith("MOTIF"):
                motif_index += 1
                content = line.strip().split(" ")
                motif_consensus = content[1]
                motif_out_name = os.path.join(dataset_name + "_motif",  dataset_name + "_" + str(motif_index) + ".meme.with_header")

                fout = open(motif_out_name, "w")
                for header_1_line in header_1_holder:
                    fout.write(header_1_line+"\n")


                header_2 = "MOTIF " + dataset_name + "." + str(motif_index) + "." +motif_consensus+"\n"

                fout.write(header_2+"\n")
            elif line.startswith("letter"):
                line_split = line.strip().split(" ")
                line_new = " ".join(line_split[:6])
                fout.write(line_new+"\n")
            elif line.startswith(("0.", "1.")):
                fout.write(line)
            else:
                next

                
def paser_meme_biopython(meme_file_name):
    """
    inputs: site file
    output: each file contain sites for each motif
    """
    dataset_name = meme_file_name.replace(".meme", "")
    motif_index = -1

    if not os.path.isdir(dataset_name+"_motif"):
        os.mkdir(dataset_name+"_motif")

    with open(meme_file_name) as fin:

        header_1_holder = []

        for i in xrange(15):
            line = fin.readline()
            header_1_holder.append(line)


        for line in fin:
            if line.startswith("MOTIF"):
                motif_index += 1
                content = line.strip().split(" ")
                motif_consensus = content[1]
                motif_out_name = os.path.join(dataset_name + "_motif",  dataset_name + "_" + str(motif_index) + ".meme.bio")

                fout = open(motif_out_name, "w")
                for header_1_line in header_1_holder:
                    fout.write(header_1_line)


                header_2 = "MOTIF " + dataset_name + "." + str(motif_index) + "." +motif_consensus+"\n"

                fout.write(header_2+"\n")
                
            elif line.startswith("letter"):
                fout.write(line)
                
            elif line.startswith(("0.", "1.")):
                fout.write(line)
            else:
                next

def paser_meme_out_meme(meme_file_name):
    """
    inputs: site file
    output: each file contain sites for each motif
    """
    dataset_name = meme_file_name.replace(".meme", "")
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
    dataset_name = motif_file_name.replace(".spic", "")
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
                header_2 = "MOTIF"+"\t"+dataset_name + "." + str(motif_index) +"." + motif_consensus + ".motif\n"
                fout.write(header_2+"\n")

            elif line.startswith(("A\t", "G\t", "C\t", "T\t", "I\t", "a\t", "g\t", "c\t", "t\t")):
                fout.write(line)
            else:
                next


def get_file_list(dataset):
    with open(dataset) as fin:
        file_list = [line.strip() for line in fin.readlines()]
    return file_list

    
def main():
    meme_file_name = sys.argv[1]

    #motif_file_name = meme_file_name.replace(".meme", ".spic")
    #site_file_name = meme_file_name.replace(".meme", ".site")

    paser_meme_biopython(meme_file_name)

    
    #paser_motif(motif_file_name)
    #paser_site(site_file_name)
    #paser_meme_out_meme(meme_file_name)
    paser_meme(meme_file_name)

if __name__=="__main__":
    main()
