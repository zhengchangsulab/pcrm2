#!/usr/bin/python
from __future__ import print_function
import glob
import os
import sys

fil = sys.argv[1]
ext_length = sys.argv[2]
reference_size = sys.argv[3]

chrom_len = {}

with open(reference_size,"r") as fin:
    for line in fin:
        content = line.rstrip().split("\t")
        chrom_len[content[0]] = int(content[1])


fin = open(fil)
new_suffix = "_"+ext_length+".bed"
founame = fil.replace(".bed",new_suffix)
fout = open(founame, "w")
header = fin.readline()
for line in fin.readlines():
    content = line.strip().split("\t")
    chrom = content[0]

    mid = int((float(content[1])+float(content[2]))/2)
    start = mid-int(ext_length)/2
    end = mid+int(ext_length)/2

    if start < 0:
        start = 0
        end = start + ext_length


    if end > chrom_len[chrom]:
        end = chrom_len[chrom]
        start = end - int(ext_length)

    content[1] = str(start)
    content[2] = str(end)
    newline = "\t".join(content)+"\n"
    fout.write(newline)

