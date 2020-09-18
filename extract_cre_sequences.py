#!/usr/bin/python
from __future__ import print_function
import sys
from collections import OrderedDict
import re
from Bio import motifs
import glob
import os
import sys
from Bio.Alphabet import IUPAC
from Bio.Seq import Seq


def build_pssm(meme):
    with open(meme) as f:
        record = motifs.parse(f, 'minimal')

    motif = record[0]
    motif.pseudocounts = motif.background
    pssm = motif.pssm

    return pssm


def build_pssm_dict(meme_bio_path):

    umotif_pssm_dict = {}
    meme_pwms = glob.glob("{}/*.meme.bio".format(meme_bio_path))

    for meme_pwm in meme_pwms:
        print(meme_pwm)
        meme_name = os.path.basename(meme_pwm)

        umotif_index = meme_name.replace(".30.8.8_0.meme.bio", "").replace("cluster_", "")
        pssm = build_pssm(meme_pwm)
        umotif_pssm_dict[umotif_index] = pssm

    return umotif_pssm_dict



def build_peak_sequences_dict(random_sequences_name):
    peak_sequences_dict = OrderedDict()
    with open(random_sequences_name) as fin:
        for line in fin:
            if line.startswith(">"):
                key = line.strip()
                peak_sequences_dict[key] = []
            else:
                peak_sequences_dict[key].append(line.strip())


    return peak_sequences_dict



def extract_random_cre_seq(peak_start, sequence, cre, umotif_pssm_dict, chrom):
    umotif_index, start, end = re.split("\||:|-", cre)
    
    random_seq_start_index = int(start) - peak_start
    random_seq_end_index = int(end) - peak_start
    
    cre_seq = sequence[random_seq_start_index:random_seq_end_index]
    

    pssm = umotif_pssm_dict[umotif_index]
    

    seq_forward = Seq(cre_seq, IUPAC.unambiguous_dna)
    seq_rc = seq_forward.reverse_complement()
    
    #forward_max_score = max(pssm.calculate(seq_forward))
    forward_max_score = pssm.calculate(seq_forward)
    #rc_max_score = max(pssm.calculate(seq_rc))
    rc_max_score = pssm.calculate(seq_rc)
    
    final_max = max([forward_max_score, rc_max_score])


    return cre_seq, final_max

def main():
    random_sequences_name = sys.argv[1]
    crm_name = sys.argv[2]
    meme_bio_path = sys.argv[3]
    random_flag = sys.argv[4]

    peak_sequences_dict = build_peak_sequences_dict(random_sequences_name)
    umotif_pssm_dict = build_pssm_dict(meme_bio_path)
    with open("{}.{}.bed.fa.score".format(crm_name, random_flag), "w") as fout:
        with open(crm_name) as fin:
            for line in fin:
                line_split = line.strip().split("\t")
                chrom = line_split[0]
                peak_name = ">{}:{}-{}".format(line_split[0], line_split[1], line_split[2])
                peak_random_sequence = peak_sequences_dict[peak_name][0]
                cre_list = line_split[3].split(",")
                
                peak_start = int(line_split[1])
                for cre in cre_list:
                    random_cre_seq, final_max = extract_random_cre_seq(peak_start, peak_random_sequence, cre, umotif_pssm_dict, chrom)
                    output = "{}\t{}\n".format(cre, str(final_max))
                    fout.write(output)

if __name__=="__main__":
    main()
