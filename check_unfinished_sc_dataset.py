#!/usr/bin/python
from __future__ import print_function
import glob
from collections import OrderedDict
import subprocess

def get_all_tf_index(file_name):

    tf_number_dict = OrderedDict()
    with open(file_name) as fin:
        for line in fin:
            tf_index = line.strip()
            motif_number = len(glob.glob(tf_index+"_motif/*.sites"))
            tf_number_dict[tf_index] = motif_number

    return tf_number_dict


def create_unfinished_file(tf_number_dict):

    fout_u_unfinish = open("un_run_Sc.u.txt", "w")
    fout_m_unfinish = open("un_run_Sc.m.txt", "w")
    for tf in tf_number_dict.keys():
        motif_number = tf_number_dict[tf]
        Sc_u_file = "Sc_Score_"+tf+".u.txt"
        Sc_m_file = "Sc_Score_"+tf+".m.txt"

        try:
            with open(Sc_u_file) as fin:
                sc_u_number = len(fin.readlines())
                if motif_number*(motif_number-1)/2 != sc_u_number:
                    create_rerun_pbs(tf, "u")
                    fout_u_unfinish.write(tf+"\n")
        except:
            create_rerun_pbs(tf, "u")
            fout_u_unfinish.write(tf+"\n")

        try:
            with open(Sc_m_file) as fin:
                sc_m_number = len(fin.readlines())
                if motif_number*(motif_number-1)/2 != sc_m_number:
                    create_rerun_pbs(tf, "m")
                    fout_m_unfinish.write(tf+"\n")
        except:
            create_rerun_pbs(tf, "m")
            fout_m_unfinish.write(tf+"\n")

    fout_u_unfinish.close()
    fout_m_unfinish.close()

def create_rerun_pbs(tf, flag):
    header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=120GB\n#PBS -l walltime=50:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd $PBS_O_WORKDIR\n"

    if flag=="m":
        cmd="java Sc_v2 "+tf
        pbs_name="run_sc_v0.3_"+tf+".r2m.pbs"
    elif flag=="u":
        cmd="python compute_Sc_v0.3.py " + tf
        pbs_name="run_sc_v0.3_"+tf+".r2u.pbs"

    with open(pbs_name, "w") as fout:
        fout.write(header)
        fout.write(cmd)

    submit_cmd="qsub "+pbs_name
    subprocess.call(submit_cmd, shell=True)

def main():
    file_name = "motifs_gt_2_in_tf.txt"

    tf_number_dict = get_all_tf_index(file_name)

    create_unfinished_file(tf_number_dict)

if __name__=="__main__":
    main()
