#!/bin/bash
cwd=$(pwd)

tomtom_script="/nobackup/zcsu_research/npy/cistrom/run_tomtom_for_umotif_single.sh"


function run_tomtom_for_umotif(){
    cp ${tomtom_script} .

    meme_files=*.meme.meme
    for meme in ${meme_files}
    do
	pbs="run_tomtom_"${meme}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_tomtom_for_umotif_single.sh ${meme}" >> ${pbs}
	qsub ${pbs}
    done
}


function run_rest_tomtom_for_umotif(){
    cp ${tomtom_script} .

    meme_files=*.meme.meme
    for meme in ${meme_files}
    do
	folder=${meme}"_hocomoco_output"

	if [[ ! -d ${folder} ]];then
	    pbs="re_run_tomtom_"${meme}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bash run_tomtom_for_umotif_single.sh ${meme}" >> ${pbs}
	    qsub ${pbs}

	fi

    done
}




cd /nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_1500/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_30/

#=============================================================================
cd UMOTIF_FOR_ALL_CLUSTER_6
cd UMOTIF_MEME
#run_tomtom_for_umotif
run_rest_tomtom_for_umotif
cd ../
cd ../

#=============================================================================
cd UMOTIF_FOR_ALL_CLUSTER_8
cd UMOTIF_MEME
#run_tomtom_for_umotif
run_rest_tomtom_for_umotif
cd ../
cd ../
#=============================================================================


cd ${cwd}
