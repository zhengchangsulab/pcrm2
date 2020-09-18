#!/bin/bash

keep_motif=$1
#keep_motif_folder=$2


#rm -rf ${keep_motif_folder}
#mkdir ${keep_motif_folder}

rm -rf MOTIF_U_PSM_GT_0.7_SPIC_FOLDER
mkdir MOTIF_U_PSM_GT_0.7_SPIC_FOLDER

rm -rf MOTIF_U_SITES_GT_0.7_FOLDER
mkdir MOTIF_U_SITES_GT_0.7_FOLDER

rm -rf MOTIF_U_PSM_GT_0.7_FOLDER
mkdir MOTIF_U_PSM_GT_0.7_FOLDER

while IFS= read -r line
do
    line_split=(`echo ${line}|tr "_" " "`)
    motif=${line_split}"_motif/"${line}".meme"
    cp ${motif} MOTIF_U_PSM_GT_0.7_FOLDER

    spic=${line_split}"_motif/"${line}".motif"
    cp ${spic} MOTIF_U_PSM_GT_0.7_SPIC_FOLDER

    site=${line_split}"_motif/"${line}".sites"
    cp ${site} MOTIF_U_SITES_GT_0.7_FOLDER

done<${keep_motif}
