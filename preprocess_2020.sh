#!/bin/bash
cwd="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"
filter_chrosome_script=${cwd}"/filter_chrosome.py"
run_batch_filter_chrosome_script=${cwd}"/run_batch_filter_chrosome.sh"
human_genome=${cwd}"/reference/hg38.fa"
mouse_genome=${cwd}"/reference/mm10.fa"
dap_genome=${cwd}"/reference/dap.fa"
ce_genome=${cwd}"/reference/ce.fa"
run_sort_filter_batch_script=${cwd}"/run_sort_filter_batch.sh"
extend_peaks_script=${cwd}"/extend_peaks.py"
run_extend_batch_script=${cwd}"/run_extend_batch.sh"
hard_mask_script=${cwd}"/hard_mask.py"
run_get_fasta_and_hard_mask_batch_script=${cwd}"/run_get_fasta_and_hard_mask_batch.sh"
run_generate_background_markov_prosampler_paser_batch_script=${cwd}"/run_generate_background_markov_prosampler_paser_batch.sh"
paser_prosampler_script=${cwd}"/paser_prosampler.py"
paser_prosampler_single_script=${cwd}"/paser_prosampler_single.py"
compute_Sc_v03_script=${cwd}"/compute_Sc_v0.3.py"
run_compute_sc_batch_script=${cwd}"/run_compute_sc_batch.sh"
plot_sc_score_script=${cwd}"/plot_sc_score.py"
run_keep_sc_motifs_script=${cwd}"/run_keep_sc_motifs.sh"
run_move_keep_motifs_script=${cwd}"/run_move_keep_motifs.sh"
modify_header_spic_and_move_script=${cwd}"/modify_header_spic_and_move.py"
modify_header_spic_and_move_v2_script=${cwd}"/modify_header_spic_and_move_v2.py"
modify_header_spic_and_move_v3_script=${cwd}"/modify_header_spic_and_move_v3.py"
compute_S0_script=${cwd}"/compute_S0.sh"
run_cat_sort_merge_dataset_script=${cwd}"/run_cat_sort_merge_dataset.sh"
count_total_bp_script=${cwd}"/count_total_bp.py"


function run_split_small_patch(){
    ls *sort_peaks.narrowPeak.bed > Narrow_Peak_Files_Name
    split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed" "Narrow_Peak_Files_Name" "small_patch_"
}

function run_filter_chrosome_script(){
    small_patch_files=small_patch_*_index.bed
    cp ${filter_chrosome_script} .
    cp ${run_batch_filter_chrosome_script} .
    
    rm run_filter_chrom_*.pbs.*{e,o}*

    for small_patch in ${small_patch_files}
    do
	pbs="run_filter_chrom_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_batch_filter_chrosome.sh ${small_patch}" >> ${pbs}
	qsub ${pbs}
    done
}

function check_un_finished_filter(){
    narrow_peaks=*sort_peaks.narrowPeak.bed
    for narrow_peak in ${narrow_peaks}
    do
	if [[ ! -f ${narrow_peak}".chr.filter" ]];then
	    echo ${narrow_peak}
	fi
    done

}


function run_move_chr_and_bed(){
    mkdir BED_AND_CHR_FILES
    mv *.bed BED_AND_CHR_FILES
    mv *.chr BED_AND_CHR_FILES
    mv BED_AND_CHR_FILES/small_patch*.bed ../
}

function sort_bed(){
    cp ${run_sort_filter_batch_script} .
    #ls *.bed.chr.filter > Peak_Chr_filter_files_Name
    #split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" "Peak_Chr_filter_files_Name" "small_patch_"    
    small_patch_files=small_patch*_index.txt
    for small_patch in ${small_patch_files}
    do
	pbs="run_sort_filter_small_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_sort_filter_batch.sh ${small_patch}" >> ${pbs}
	qsub ${pbs}
    done

}


function check_unfinished_sort(){
    filters=*.filter
    for filter in ${filters}
    do
	sort="Sorted/"${filter}".sort"
	if [[ ! -f ${sort} ]];then
	    echo ${filter}
	fi
    done

}

function run_extend_peak(){
    cp ${extend_peaks_script} .
    cp ${run_extend_batch_script} .


    extend_length=$1
    data_name=$2
    spices=${data_name/"_factor"/}

    ref_genome=${cwd}"/reference/"${spices}".chrom.sizes"

    all_file_name="Peak_Chr_filter_Sorted_files_Name"
    ls *.bed.chr.filter.sort > ${all_file_name}
    split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" ${all_file_name} "small_patch_"    
    small_patch_files=small_patch*_index.txt
    
    for small_patch in ${small_patch_files}
    do
	pbs="run_sort_filter_small_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_extend_batch.sh ${small_patch} ${extend_length} ${ref_genome}" >> ${pbs}
        qsub ${pbs}
    done
}

function run_check_unfinished_extend(){
    sorted=*.sort
    for sort in ${sorted}
    do
	output="extend_1000/"${sort}".extend_1000"
	if [[ ! -f ${output} ]];then
	    echo ${sort}
	fi
    done

}

function run_get_fasta_and_hard_mask(){
    data_name=$1

    cp ${hard_mask_script} .
    cp ${run_get_fasta_and_hard_mask_batch_script} .

    spices=${data_name/"_factor"/}

    ref_genome=${cwd}"/reference/"${spices}".fa"

    all_file_name="Peak_Chr_filter_Sorted_Extend_files_Name"
    ls *.bed.chr.filter.sort.extend_1000 > ${all_file_name}
    split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" ${all_file_name} "small_patch_"    
    small_patch_files=small_patch*_index.txt
    
    for small_patch in ${small_patch_files}
    do
	pbs="run_get_fasta_and_hard_mask_small_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_get_fasta_and_hard_mask_batch.sh ${small_patch} ${ref_genome}" >> ${pbs}
        qsub ${pbs}
    done
}


function run_check_unfinished_mask(){
    extend_files=*.extend_1000
    for extend in ${extend_files}
    do
	hard_mask="Hard_Mask/"${extend}".fa.hard"
	if [[ ! -f ${hard_mask} ]];then
	    echo ${extend}
	fi
    done
}


function run_markov_bg_prosampler(){
    cp ${run_generate_background_markov_prosampler_paser_batch_script} .
    cp ${paser_prosampler_single_script} .
    
    all_file_name="Peak_Chr_filter_Sorted_Extend_Fa_Hard_files_Name"
    ls *.bed.chr.filter.sort.extend_1000.fa.hard > ${all_file_name}
    split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" ${all_file_name} "small_patch_"    
    small_patch_files=small_patch*_index.txt
    
    for small_patch in ${small_patch_files}
    do
	pbs="run_get_bg_prosampler_paser_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_generate_background_markov_prosampler_paser_batch.sh ${small_patch}" >> ${pbs}
        qsub ${pbs}
    done
}



function run_check_unfisheh_prosampler(){
    hard_files=*extend_1000.fa.hard
    for hard in ${hard_files}
    do
	bg_name=${hard}".markov.bg"
	if [[ ! -f ${bg_name} ]];then
	    pbs="run_unfinished_bg_prosampler_pasar_"${hard}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "markov -i ${hard} -b ${hard}.markov.bg" >> ${pbs}
	    echo -e "output=${hard}.prosampler.txt" >> ${pbs}
	    echo -e "ProSampler -i ${hard} -b ${hard}.markov.bg -o \${output}" >> ${pbs}
	    echo -e "python paser_prosampler_single.py \${output}.meme" >> ${pbs}
	    qsub ${pbs}
	fi

    done

}


function run_compute_sc_batch(){
    cp ${compute_Sc_v03_script} . 
    cp ${run_compute_sc_batch_script} .
 
    all_file_name="Peak_Chr_filter_Sorted_Extend_Fa_Hard_Prosampler_files_Name"
    ls *.bed.chr.filter.sort.extend_1000.fa.hard > ${all_file_name}
    split -l 25 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" ${all_file_name} "small_patch_prosampler_"    
    small_patch_files=small_patch_prosampler*_index.txt
    
    for small_patch in ${small_patch_files}
    do
	pbs="run_compute_sc_score_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_compute_sc_batch.sh ${small_patch}" >> ${pbs}
        qsub ${pbs}
    done

}

function run_unfinished_sc(){

    hard_files=*extend_1000.fa.hard.prosampler.txt.meme
    for hard in ${hard_files}
    do
	name_split=(`echo ${hard}|tr "." " "`)
	index=${name_split[0]}
	Sc="Sc_Score_"${index}".u.txt"
	if [[ ! -f ${Sc} ]];then
	    pbs="run_compute_sc_"${index}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python compute_Sc_v0.3.py ${index}" >> ${pbs}
	    echo ${pbs}
	fi
    done
}


function run_cat_sc_score(){
    pbs="run_cat_score.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "cat Sc_Score_*.u.txt > Sc_score_1000.u.total.txt" >> ${pbs}
    qsub ${pbs}
}


function run_plot_sc_score(){
    cp ${plot_sc_score_script} .
    for bw in 0.1 0.05 0.01 0.005 0.002
    do
	pbs="run_plot_sc_"${bw}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python plot_sc_score.py Sc_score_1000.u.total.txt ${bw}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_cutoff_total_score(){
    #cutoff=0.7
    cutoff=0.4
    pbs="run_keep_sc_score_"${cutoff}".pbs"
    echo -e ${pbs_header} > ${pbs}
    #echo -e "awk '\$3>=0.7' Sc_score_1000.u.total.txt > Sc_score_1000.u.total.txt.gt_0.7" >> ${pbs}
    echo -e "awk '\$3>=0.4' Sc_score_1000.u.total.txt > Sc_score_1000.u.total.txt.gt_0.4" >> ${pbs}
    qsub ${pbs}
}

function run_keep_motif_sc(){
    cp ${run_keep_sc_motifs_script} .
    pbs="run_keep_motifs_gt_0.7.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_keep_sc_motifs.sh" >> ${pbs}
    qsub ${pbs}
}

function run_move_keep_motif_spic(){
    cutoff=$1
    cp ${run_move_keep_motifs_script} .
    pbs="run_move_keep_motifs_"${cutoff}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_move_keep_motifs.sh ${cutoff}" >> ${pbs}
    qsub ${pbs}
}


function run_modify_motif(){
    s=$1
    cutoff=0.7
    folder="MOTIF_U_PSM_GT_"${cutoff}"_SPIC_FOLDER"
    cp "Sc_score_1000.u.total.txt.gt_"${cutoff}".keep_motifs" ${folder}
    cd ${folder}
    cp ${modify_header_spic_and_move_script} .
    rm small_patch_keep_motifs*_index.txt
    split -l 10000 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" Sc_score_1000.u.total.txt.gt_0.7.keep_motifs "small_patch_keep_motifs_"    
    small_patch_files=small_patch_keep_motifs*_index.txt
    for small_patch in ${small_patch_files}
    do
	pbs="run_compute_sc_score_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python modify_header_spic_and_move.py ${s} ${small_patch}" >> ${pbs}
	qsub ${pbs}
    done
    cd ../
}

function run_modify_motif_v3_human(){
    s=$1
    cutoff=0.7
    folder="MOTIF_U_PSM_GT_"${cutoff}"_SPIC_FOLDER"
    cd ${folder}
    #rm small_patch_keep_motifs_*.txt
    cp ${modify_header_spic_and_move_v3_script} .
    pbs="run_modify_spic_and_move.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python modify_header_spic_and_move_v3.py ${s}" >> ${pbs}
    qsub ${pbs}
    cd ../
}


function run_compute_s0(){
    #ls *.sort|wc -l
    #ls *.sort > Narrow_Peak_Files_Name
    #split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed" "Narrow_Peak_Files_Name" "small_patch_overlap_"

    cp ${compute_S0_script} .
    
    for small_patch in small_patch_overlap_*index.bed
    do
	pbs="run_get_overlap_with_other_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_S0.sh ${small_patch}" >> ${pbs}
	qsub ${pbs}
    done


}


function run_rest_compute_s0(){
    #ls *.sort|wc -l
    #ls *.sort > Narrow_Peak_Files_Name
    #split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed" "Narrow_Peak_Files_Name" "small_patch_overlap_"

    sorts=*bed.chr.filter.sort

    rm -f Rest_Narrow_Peak_Files_Name

    for sort in ${sorts}
    do
	with_other=${sort}".overlap_with_others.txt"
	if [[ ! -f ${with_other} ]];then
	    echo ${sort} >> Rest_Narrow_Peak_Files_Name
	fi
    done

    rm -f small_patch_overlap_rest_rest_*index.bed
    split -l 5 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed" "Rest_Narrow_Peak_Files_Name" "small_patch_overlap_rest_rest_"

    cp ${compute_S0_script} .
    
    for small_patch in small_patch_overlap_rest_rest_*index.bed
    do
	pbs="run_get_overlap_with_other_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_S0.sh ${small_patch}" >> ${pbs}
	qsub ${pbs}
    done


}


function run_merge_all_dataset(){
    pbs="run_merge_and_sort_all_dataset.pbs"
    cp ${run_cat_sort_merge_dataset_script} .
    cp ${count_total_bp_script} .
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_cat_sort_merge_dataset.sh" >> ${pbs}
    qsub ${pbs}
}



for folder in ce_factor dap_factor #human_factor mouse_factor #
do
    cd ${folder}
    #run_split_small_patch
    #run_filter_chrosome_script
    #check_un_finished_filter
    #sort_bed
    #check_unfinished_sort
    cd Sorted
    #run_extend_peak 1000 ${folder}
    #run_check_unfinished_extend
    #run_compute_s0

    #run_compute_s0
    #run_rest_compute_s0
    #run_merge_all_dataset

    cd extend_1000
    #run_get_fasta_and_hard_mask ${folder}
    #run_check_unfinished_mask
    #run_merge_all_dataset

    cd Hard_Mask
    #run_markov_bg_prosampler
    #run_check_unfisheh_prosampler
    #run_compute_sc_batch
    #run_unfinished_sc
    #run_cat_sc_score
    #run_plot_sc_score
    #run_cutoff_total_score
    #run_keep_motif_sc
    #run_move_keep_motif_spic 0.7
    run_modify_motif ${folder}
    #run_modify_motif_v3_human ${folder}
    cd ../
    cd ../
    cd ../
    cd ../
done
