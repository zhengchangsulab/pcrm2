#!/bin/bash

#Pool_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder
Pool_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_None_Folder"

cwd="/nobackup/zcsu_research/npy/cistrom/"

sort_extend_bed_script="/nobackup/zcsu_research/npy/cistrom/sort_extend_bed.sh"
for f in TF_human
do
    cd ${Pool_folder}
    for length in 1000 1500 3000
    do
	extend_folder=${Pool_folder}"/extend_to_"${length}
	cp ${sort_extend_bed_script} ${extend_folder}
	
	cd ${extend_folder}
	pbs="run_sort_extend_bed.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash sort_extend_bed.sh" >> ${pbs}
        qsub ${pbs}
    done
    cd ${cwd}
done
