#!/usr/bin/python
from __future__ import print_function
import glob
import os

def main():
    keep_tfbs_files = glob.glob("*KEEP_TFBS")

    total_merge = "Merge_CRM_Norm/TOTAL_KEEP_BINDING_SITES_Norm.bed"


    fout = open(total_merge, "w")

    for keep_tfbs in keep_tfbs_files:
        with open(keep_tfbs) as fin:
            for line in fin:
                fout.write(line)

    fout.close()


if __name__=="__main__":
    main()
