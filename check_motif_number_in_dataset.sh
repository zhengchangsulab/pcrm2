#!/bin/bash

cwd="/nobackup/zcsu_research/npy/cistrom"


function check_motif_number(){

    meme_files=*.meme

    if [[ -f motif_number_in_tf.txt ]];then
	rm motif_number_in_tf.txt
    fi

    if [[ -f motifs_gt_2_in_tf.txt ]];then
	rm motifs_gt_2_in_tf.txt
    fi

    if [[ -f motifs_lt_2_in_tf.txt ]];then
	rm motifs_lt_2_in_tf.txt
    fi

    if [[ -f paser_motif_not_finish.txt ]];then
	rm paser_motif_not_finish.txt
    fi
    for meme in ${meme_files}
    do
	motif_number=(`more ${meme}|grep "^MOTIF"|wc -l`)
	tf_index=(`echo ${meme}|tr "_" " "`)
	paser_motif_number=(`ls ${tf_index}"_motif/"*".meme"|wc -l`)

	echo ${tf_index}":"${motif_number} >> motif_number_in_tf.txt
	
	if [[ ${motif_number} -gt ${paser_motif_number} ]];then
	    echo ${tf_index} >> paser_motif_not_finish.txt
	fi

	if [[ ${motif_number} -lt 2 ]];then
	    echo ${tf_index} >> motifs_lt_2_in_tf.txt

	else
	    echo ${tf_index} >> motifs_gt_2_in_tf.txt
	fi


    done
}

function check_motif_less_2(){
    
    rm motifs_lt_2_in_tf.txt
    rm motifs_gt_2_in_tf.txt

    while IFS= read -r line
    do
	line_split=(`echo ${line}|tr ":" " "`)
	tf_index=${line_split[0]}
	motif_number=${line_split[1]}

	if [[ ${motif_number} -lt 2 ]];then
	    echo ${tf_index} >> motifs_lt_2_in_tf.txt
	else
	    echo ${tf_index} >> motifs_gt_2_in_tf.txt
	fi

    done<"motif_number_in_tf.txt"
    
}

for length in 1000 1500 3000
do
    human_fa="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_"${length}"/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS"
    cd ${human_fa}
    check_motif_number
    #check_motif_less_2
    #cp motifs_gt_2_in_tf.txt MOTIFS
    cd ${cwd}
done



#mouse_fa="/nobackup/zcsu_research/npy/cistrom/TF_mouse/TF_mouse_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/Fasta_File/Hard_Fasta_File/"
#cd ${mouse_fa}
#check_motif_number
#check_motif_less_2
#cp motifs_gt_2_in_tf.txt MOTIFS
#cd ${cwd}
