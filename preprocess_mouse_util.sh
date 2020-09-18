#!/bin/bash
# code before 2/42019
function run_extend_all_peaks(){
    length=$1
    ref_size=$2
    extend_folder=$3
    mkdir ${extend_folder}
    bash extent_all_files.sh ${length} ${ref_size} ${extend_folder}
}

function run_sort_extend_peak () {
    cp ${sort_extend_peak_path} .
    pbs=sort_extend_bed.pbs
    echo -e $pbs_header > $pbs
    echo -e "bash sort_extend_bed.sh">> $pbs
    qsub $pbs
}

function run_convert_bed_to_fasta(){
    cp ${convert_bed_to_fasta_path} .
    bash convert_bed_fasta.sh ${mm10_fa}

}

function create_hard_mask_pbs () {
    cp ${hard_mask_path} .
    files=*_sort.bed.fa
    for f in ${files}
    do
	pbs="run_hard_mask_"${f}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python hard_mask.py ${f}" >> ${pbs}
	qsub ${pbs}
    done

}

function run_get_background_pbs(){
    hard_files=*_sort.bed.fa.hard
    for hard in ${hard_files}
    do
	pbs="run_markov_"${hard}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "markov -i ${hard} -b ${hard}.markov.bg" >> ${pbs}
	qsub ${pbs}
    done
}

function rerun_un_run_background_pbs(){
    hard_files=*_sort.bed.fa.hard
    for hard in ${hard_files}
    do
	if [[ ! -f ${hard}.markov.bg ]];then
	    pbs="run_markov_"${hard}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "markov -i ${hard} -b ${hard}.markov.bg" >> ${pbs}
	    echo ${pbs}

	fi
    done

}

function run_prosampler_pbs(){
    hard_files=*_sort.bed.fa.hard
    for hard in ${hard_files}
    do
	pbs="run_prosampler_"${hard}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "ProSampler -i ${hard} -b ${hard}.markov.bg -o ${hard}.prosampler.txt" >> ${pbs}
	qsub ${pbs}
    done

}


function check_unrun_prosampler_pbs(){
    hard_files=*_sort.bed.fa.hard
    for hard in ${hard_files}
    do
	if [[ ! -f ${hard}.prosampler.txt.site ]];then
	    pbs="run_prosampler_"${hard}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "ProSampler -i ${hard} -b ${hard}.markov.bg -o ${hard}.prosampler.txt" >> ${pbs}
	    qsub ${pbs}
	fi

    done

}

function run_paser_prosampler(){
    cp ${paser_prosampler_path} .
    meme_files=*hard.prosampler.txt.meme
    for meme in ${meme_files}
    do
	pbs="run_paser_prosampler_"${meme}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler_single.py ${meme}" >> ${pbs}
	qsub ${pbs}
    done
}

function check_un_paser_prosampler(){
    meme_files=*hard.prosampler.txt.meme
    for meme in ${meme_files}
    do
	tf_index=${meme%%_*}
	output_folder=${tf_index}"_motif"
	if [[ ! -d ${output_folder} ]];then
	    pbs="run_paser_prosampler_"${meme}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python paser_prosampler_single.py ${meme}" >> ${pbs}
	    qsub ${pbs}
	fi
    done

}


function run_compute_sc_score(){
    cp ${compute_sc_score_path} .
    meme_files=*hard.prosampler.txt.meme
    for meme in ${meme_files}
    do
	tf_index=${meme%%_*}
	pbs="run_compute_sc_"${tf_index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_Sc_v0.3.py ${tf_index}" >> ${pbs}
	qsub ${pbs}
    done
}


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
#########################################################################
# code before 4/9/2018
function run_plot_sc(){
    cp ${plot_sc_path} .
    pbs="run_plot_sc_hist.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_Sc_dist.py Sc_score_mouse_1500.u.total.txt" >> ${pbs}
    qsub ${pbs}
    
}


function run_keep_Sc_gt_than_threshold(){
    #awk '$3>=0.7' Sc_score_mouse_1500.u.total.txt >> Sc_score_mouse_1500.u.keep_0.7.txt
    awk '$3>=0.7{print $1"\n"$2}' Sc_score_mouse_1500.u.total.txt|sort|uniq > Sc_score_human_1500.u.total_0.7.keep_motif.txt
}

function run_build_keep_motif_dataset(){
    cp ${build_keep_motif_dataset_path} .
    pbs="run_build_keep_motif_script.u.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_keep_motif_dataset.sh Sc_score_mouse_1500.u.total_0.7.keep_motif.txt" >> ${pbs}
    qsub ${pbs}
}

function run_copy_spic_to_group(){
    pbs="run_copy_spic_to_group.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "cp -r MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/ /nobackup/zcsu_research/" >> ${pbs}
    qsub ${pbs}

}
