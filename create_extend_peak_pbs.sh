#!/bin/bash

for f in TF_human #TF_mouse
do

    echo ${f}
    file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_None_Folder"
    current_folder=$(pwd)
    cp extent_all_files.sh $file_path
    cp extend_peaks.py $file_path
    cd $file_path

    if [[ ${f} == "TF_human" ]]
    then
	ref_size="/nobackup/zcsu_research/npy/cistrom/reference/hg38.chrom.sizes"
    elif [[ ${f} == "TF_mouse" ]]
    then
	ref_size="/nobackup/zcsu_research/npy/cistrom/reference/mm10.chrom.sizes"
    fi
    
    for length in 1000 1500 3000
    do
	extend_peak_folder="extend_to_"${length}
	if [[ ! -d ${extend_peak_folder} ]];then
	    mkdir ${extend_peak_folder}
	fi
	
	pbs=${f}.extent_${length}.pbs
	echo -e $pbs_header > $pbs
	
	echo ${ref_size}
	echo -e "bash extent_all_files.sh ${length} ${ref_size} ${extend_peak_folder}" >> $pbs
	qsub $pbs

    done

    cd $current_folder

done


