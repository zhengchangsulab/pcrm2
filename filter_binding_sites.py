#!/usr/bin/python
from __future__ import print_function
import sys



def main():
    umotif_bed_name = sys.argv[1]

    fout = open(umotif_bed_name+".clean", "w")
    with open(umotif_bed_name) as fin:
        for line in fin:
            line_strip = line.strip().split("\t")
            binding_site = "\t".join(line_strip[:3])
            from_peak = ",".join(list(set(line_strip[3].split(","))))
            new_line = binding_site + "\t" + from_peak +"\n"
            fout.write(new_line)


if __name__=="__main__":
    main()
