#!/usr/bin/python
from __future__ import print_function
import glob

def main():

    fout_less_2 = open("dataset_less_than_2_motif.txt", "w")
    fout_un_run = open("un_run_Sc.m.txt", "w")

    hard_files = glob.glob("../*.hard")
    for hard in hard_files:
        print(hard)
        dataset_index = hard.replace("../", "").split("_")[0]
        print(dataset_index)
        pattern = dataset_index+"_motif/"+"*.sites"
        motif_list = glob.glob(pattern)

        if len(motif_list) <= 1:
            line = dataset_index + "\t" + str(len(motif_list)) + "\n"
            fout_less_2.write(line)


        motif_number = len(motif_list)
        Sc_file = "Sc_Score_"+dataset_index+".m.txt"
        try:
            with open(Sc_file) as fin:
                sc_number = len(fin.readlines())
                if motif_number*(motif_number-1)/2 != sc_number:
                    fout_un_run.write(dataset_index+"\n")
        except:
            fout_un_run.write(dataset_index+"\n")

    fout_less_2.close()
    fout_un_run.close()
if __name__=="__main__":
    main()
