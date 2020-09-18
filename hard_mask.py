#!/usr/bin/python
from __future__ import print_function
import sys
from re import sub

def main():
    fasta_file_name=sys.argv[1]
    #hard_mask_file_name=fasta_file_name.replace(".fa",".fa.hard")
    hard_mask_file_name=fasta_file_name+".hard"
    fout=open(hard_mask_file_name,"w")
    with open(fasta_file_name) as fin:
        for line in fin:
            if line.startswith(">"):
                fout.write(line)
            else:
                fout.write(sub("[a-z]","N",line.strip())+"\n")

    fout.close()


if __name__=="__main__":
    main()
