#!/usr/bin/python
from __future__ import print_function


import sys
import glob


def convert(site):
    fout = open(site+".bed", "w")
    with open(site) as fin:
        for line in fin:
            if line.startswith("chr"):
                line_split = line.strip().split("\t")
                #skip bad line
                if len(line_split) == 4:
                    chrosome = line_split[0].split(":")[0]
                    peak_start = int(line_split[0].split(":")[1].split("-")[0])
                    peak_end = int(line_split[0].split(":")[1].split("-")[1])
                    
                    bs_start, bs_end = line_split[2:]
                    
                    bs_start = int(bs_start)
                    bs_end = int(bs_end)
                    if line_split[1] == "+":
                        start = peak_start + bs_start - 8
                        end = peak_start + bs_end + 1 + 8
                    elif line_split[1] == "-":
                        start = peak_start + bs_start + 1 - 8 
                        end = peak_start + bs_end + 1 + 8


                    new_line = chrosome +"\t"+ str(start)+"\t"+str(end)+"\t"+line
                    fout.write(new_line)

    fout.close()

    
def main():

    sites=glob.glob("*.sites")
    for site in sites:
        convert(site)



if __name__=="__main__":
    main()
