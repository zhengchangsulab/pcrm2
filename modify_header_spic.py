#!/usr/bin/python
from __future__ import print_function
import sys
import shutil
import glob

def modify_spic(spic_file):
    with open(spic_file.replace(".motif", ".spic"), "w") as fout:
        with open(spic_file) as fin:
            lines = fin.readlines()
            header = "_".join(lines[0].split(".")[:2])+"\n"
            lines[0] = header
        
        for line in lines:
            fout.write(line)
            
                
def main():
    files=glob.glob("*.motif")
    for spic_file in files:
        modify_spic(spic_file)


if __name__=="__main__":
    main()
