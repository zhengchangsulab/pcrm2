#!/usr/bin/python

from __future__ import print_function
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

    mean = motif.pssm.mean()
    std = motif.pssm.std()
    consensus = motif.consensus
    #distribution = motif.pssm.distribution(background = motif.background)
    max_value = motif.pssm.max
    min_value = motif.pssm.min
    #print(pssm, mean, std,consensus, max_value, min_value)
    
    cutoff_1 = [mean - std, 0][(mean - std) < 0]
    cutoff_2 = [mean - 2*std, 0][(mean - 2*std) < 0]

    cutoff_3 = [mean + std, 0][(mean + std) < 0]
    cutoff_4 = [mean + 2*std, 0][(mean + 2*std) < 0]
    return pssm, mean, std, max_value, cutoff_1, cutoff_2, cutoff_3, cutoff_4
    

def build_pssm_dict():

    umotif_pssm_dict = {}
    meme_pwms = glob.glob("*.meme.bio")

    with open("umotif_score_stats.txt", "w") as fout:
        for meme_pwm in meme_pwms:
            meme_name = os.path.basename(meme_pwm)
            umotif_index = meme_name.replace(".30.8.8_0.meme.bio", "").replace("cluster_", "")
            pssm, mean, std, max_value, cutoff_1, cutoff_2, cutoff_3, cutoff_4 = build_pssm(meme_pwm)
            #umotif_pssm_dict[umotif_index] = pssm
            output = "{}\t{}|{}|{}|{}|{}|{}|{}\n".format(umotif_index, mean, std, max_value, cutoff_1, cutoff_2, cutoff_3, cutoff_4)
            fout.write(output)
            
            #return umotif_pssm_dict


def main():
    build_pssm_dict()
    
            
if __name__=="__main__":
    main()
