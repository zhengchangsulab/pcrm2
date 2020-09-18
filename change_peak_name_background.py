#!/usr/bin/python
from __future__ import print_function
from collections import OrderedDict
import sys


def main():
    fasta_name = sys.argv[1]
    background_name = sys.argv[2]

    fasta_peak_list = []
    seq_length_list = []


    with open(fasta_name) as fin:
        for line in fin:

            if line.startswith(">"):
                peak = line.strip()
                fasta_peak_list.append(peak)
            else:
                seq_length_list.append(len(line.strip()))


    background_list = []
    bk_length_list = []
    
    with open(background_name) as fin:
        for line in fin:
            if line.startswith(">"):
                peak = line.strip()
                background_list.append(peak)
            else:
                bk_length_list.append(len(line.strip()))

    fasta_back_peak_dict = OrderedDict()

    if len(background_list) == len(fasta_peak_list):
        for index in xrange(len(background_list)):
            if seq_length_list[index] == bk_length_list[index]:
                fasta_back_peak_dict[index] = {background_list[index]:fasta_peak_list[index]}

            else:
                print(fasta_peak_list[index], background_list[index], seq_length_list[index], bk_length_list[index])

    else:
        print("length is not same")


    with open(background_name+".fasta_peak_name", "w") as fout:
        index = 0
        with open(background_name) as fin:
            for line in fin:
                if line.startswith(">"):
                    bk_peak_name = line.strip()
                    fasta_bk_dict = fasta_back_peak_dict[index]
                    fasta_bk_key = fasta_bk_dict.keys()[0]

                    index += 1
                    if fasta_bk_key == bk_peak_name:
                        output = fasta_bk_dict[bk_peak_name]
                        fout.write(output+"\n")
                    else:
                        print(bk_peak_name, str(index))


                else:
                    output = line
                    fout.write(output)

if __name__=="__main__":
    main()
