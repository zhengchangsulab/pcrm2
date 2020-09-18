#!/bin/bash
filename="Sc_score_1000.u.total.txt.gt_0.4"
awk '{print $1"\n"$2}' ${filename}|sort|uniq > ${filename}".keep_motifs"
