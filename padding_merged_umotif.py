#!/usr/bin/python
from __future__ import print_function
import sys


def paser_hg_38_size(reference_size_name):
    chrom_len = {}

    with open(reference_size_name,"r") as fin:
        for line in fin:
            content = line.rstrip().split("\t")
            chrom_len[content[0]] = int(content[1])

    return chrom_len

def main():
    bed_file_name = sys.argv[1]
    ext_length = sys.argv[2]
    reference_size_name = sys.argv[3]
    
    chrom_len = paser_hg_38_size(reference_size_name)

    with open("{}.padding_{}".format(bed_file_name, ext_length), "w") as fout:
        with open(bed_file_name) as fin:
            for line in fin:
                content = line.strip().split("\t")
                chrom = content[0]
                
                if float(content[2]) - float(content[1]) < float(ext_length):
                    mid = int((float(content[1])+float(content[2]))/2)
                    start = int(mid-int(ext_length)/2)
                    end = int(mid+int(ext_length)/2)
                    
                    if start < 0:
                        start = 0
                        end = start + ext_length
                        
                        
                    if end > chrom_len[chrom]:
                        end = chrom_len[chrom]
                        start = end - int(ext_length)

            
                    #content[1] = str(start)
                    #content[2] = str(end)
            

                newline = content[0]+"\t"+str(start)+"\t"+str(end)+"\t"+content[1]+":"+content[2]+"\t"+"\t".join(content[3:])+"\n"
                fout.write(newline)



if __name__=="__main__":
    main()
