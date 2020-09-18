#!/bin/bash
dataset_path="/nobackup/zcsu_research/npy/cistrom/motif_databases/human_motif_dataset/"

hocomoco=${dataset_path}"/HOCOMOCOv11_core_HUMAN_mono_meme_format.meme"
jasper=${dataset_path}"/JASPAR2018_CORE_vertebrates_non-redundant.meme"
cis_bp=${dataset_path}"/Homo_sapiens_cis-bp.meme"


umotif=$1

hocomoco_folder=${umotif}"_hocomoco_output"
jasper_folder=${umotif}"_jasper_output"
cis_bp_folder=${umotif}"_cis_bp_output"


tomtom -verbosity 1 -evalue -thresh 0.1 ${umotif} ${hocomoco} -oc ${hocomoco_folder} -png
tomtom -verbosity 1 -evalue -thresh 0.1 ${umotif} ${jasper} -oc ${jasper_folder} -png
tomtom -verbosity 1 -evalue -thresh 0.1 ${umotif} ${cis_bp} -oc ${cis_bp_folder} -png
