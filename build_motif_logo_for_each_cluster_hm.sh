#!/bin/bash

inflation=$1
clusters="dump.out.ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.mci.bin.multi_threads.I"${inflation}".cluster"
new_folder_name="Cluster_Inflation_"${inflation}

#if [[ ! -d ${new_folder_name} ]];then
    #mkdir ${new_folder_name}
#else
    #rm -rf ${new_folder_name}
    #mkdir ${new_folder_name}
#fi
mkdir -p ${new_folder_name}


cluster_index=0
while IFS= read -r cluster
do
    
    cd ${new_folder_name}
    ((cluster_index++))

    cluster_folder="cluster_"${cluster_index}
    #if [[ ! -d ${cluster_folder} ]];then
	#mkdir ${cluster_folder}
    #else
	#rm -rf ${cluster_folder}
#	:
 #   fi

    mkdir -p ${cluster_folder}

    motif_in_cluster=(`echo ${cluster}`)

    for motif in ${motif_in_cluster[@]}

    do
	#dataset_name=(`echo ${motif} | rev | cut -d"_" -f2-  | rev`)
	dataset_name=(`echo ${motif}|tr "_" " "`)
	dataset_motif_folder_name=${dataset_name}"_sort_peaks_motif/"
	motif_meme_name=${dataset_name[0]}"_sort_peaks_"${dataset_name[1]}".meme"
	#motif_meme_with_header=${motif}".meme.with_header"
	#motif_meme_with_bio=${motif}".meme.bio"
	meme_path="../../"${dataset_motif_folder_name}${motif_meme_name}
	#meme_with_header_path="../../"${dataset_motif_folder_name}${motif_meme_with_header}
	#meme_with_bio_path="../../"${dataset_motif_folder_name}${motif_meme_with_bio}

	cp ${meme_path} ${cluster_folder}
	#cp ${meme_with_header_path} ${cluster_folder}
	#cp ${meme_with_bio_path} ${cluster_folder}
	
    done
    cd ../


done<${clusters}
