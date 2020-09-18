#!/usr/bin/python
from __future__ import print_function
import glob
import os

def main():
    spic_files = glob.glob("*.spic")
    for i in xrange(len(spic_files)-1):
        spic_file_with_pair = spic_files[i]+".with_pair"
        with open(spic_file_with_pair, "w") as fout:
            for j in xrange(i+1, len(spic_files)):
                fout.write(spic_files[j]+"\n")
        


if __name__=="__main__":
    main()
