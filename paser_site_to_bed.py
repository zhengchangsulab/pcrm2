#!/usr/bin/python
from __future__ import print_function
import glob
import sys

def paser_site_to_bed(sites_file, padding):

    padding = int(padding)

    if padding == 0:
        bed_sites_file="./SITES_BED/"+sites_file+".bed"
    else:
        bed_sites_file=sites_file+".bed."+str(padding)+".padding"



    with open(bed_sites_file, "w") as fout:
        with open(sites_file) as fin:
            header = fin.readline()
            for line in fin.readlines():
                line_split = line.strip().split("\t")

                if len(line_split) == 4:
                    chrosome = line_split[0].split(":")[0]
                    peak_start = int(line_split[0].split(":")[1].split("-")[0])
                    peak_end = int(line_split[0].split(":")[1].split("-")[1])
                    
                    bs_start, bs_end = line_split[2:]
                    
                    bs_start = int(bs_start)
                    bs_end = int(bs_end)
                    
                    start = peak_start + bs_start
                    end = peak_start + bs_end + 1

                    
                    # padding 2 bps for each end
                    start = start - padding
                    end = end + padding
                    new_info = sites_file.replace(".sites", "")+":"+line_split[0]+"\t"+"."
                    new_line = chrosome +"\t"+ str(start)+"\t"+str(end)+"\t"+new_info+"\t"+"\t".join(line_split[1:])+"\n"
                    fout.write(new_line)


def paser_sites_files(sites_files, padding):
    for sites_file in sites_files:
        paser_site_to_bed(sites_file, padding)


def get_sites_name(site_patch):
    with open(site_patch) as fin:
        sites_list = [line.strip() for line in fin]
    return sites_list

def main():
    site_patch_name = sys.argv[1]
    padding = sys.argv[2]
    sites_files_list = get_sites_name(site_patch_name)
    paser_sites_files(sites_files_list, padding)

if __name__=="__main__":
    main()
