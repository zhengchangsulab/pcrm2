#!/usr/bin/python
from __future__ import print_function
import sys

def main():
    size_file=sys.argv[1]
    total_M = int(sys.argv[2])
    tag = sys.argv[3]

    total_patch_size = total_M * 1024
    with open(size_file) as fin:
        current_patch_size = 0
        small_patch_index = 1

        fout = open(tag+"_"+str(small_patch_index),"w")
        for line in fin:
            size, file_name = line.split("\t")
            current_patch_size += int(size)
            if current_patch_size < total_patch_size:
                fout.write(file_name)
            else:
                current_patch_size = 0
                small_patch_index += 1
                fout.close()
                fout = open(tag+"_"+str(small_patch_index),"w")
                fout.write(file_name)
        fout.close()

if __name__=="__main__":
    main()
