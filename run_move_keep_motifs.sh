#!/bin/bash

cutoff=$1

folder="MOTIF_U_PSM_GT_"${cutoff}"_SPIC_FOLDER"
keep_motifs_name="Sc_score_1000.u.total.txt.gt_"${cutoff}".keep_motifs"


mkdir -p ${folder}

while IFS= read -r line
do
    line_split=(`echo ${line}|tr "_" " "`)
    #folder_name=${line_split[0]}"_"${line_split[1]}"_"${line_split[2]}"_motif/"
    # if dap
    folder_name=${line_split[0]}"_"${line_split[1]}"_"${line_split[2]}"_"${line_split[3]}"_"${line_split[4]}"_"${${line_split[5]}}"_motif/"
    file_name=${folder_name}${line}".motif"
    cp ${file_name} ${folder} 

done<${keep_motifs_name}
