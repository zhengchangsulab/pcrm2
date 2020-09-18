#!/bin/bash
function run_count_motifs(){
    folders=*_motif
    for folder in ${folders}
    do
	number=(`ls ${folder}/*.sites|wc -l`)
	echo -e ${folder/"_motif"/}":"${number} >> motif_number_in_tf.txt
    done
}


function run_get_tf_index_gt_2_motif(){
    awk -F":" '{if ($2>=2)print $1}' motif_number_in_tf.txt >> motifs_gt_2_in_tf.txt
}





function run_cat_sc_score_into_total(){
    cat Sc_Score_*.u.txt > Sc_score_mouse_1500.u.total.txt
}

function run_keep_Sc_gt_than_threshold(){
    awk '$3>=0.7{print $1"\n"$2}' Sc_score_mouse_1000.u.total.txt|sort|uniq > Sc_score_mouse_1000.u.total_0.7.keep_motif.txt
}


#run_count_motifs
#run_get_tf_index_gt_2_motif
run_keep_Sc_gt_than_threshold
