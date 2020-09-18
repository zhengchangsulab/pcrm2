#!/bin/bash

human_fa_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/"
mouse_fa_folder="/nobackup/zcsu_research/npy/cistrom/TF_mouse/TF_mouse_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/"

current_working_folder=$(pwd) #"/nobackup/zcsu_research/npy/cistrom/"
#scripts path
sort_extend_peak_path="/nobackup/zcsu_research/npy/cistrom/sort_extend_bed.sh"
create_hard_mask_pbs_path="/nobackup/zcsu_research/npy/cistrom/create_hard_mask_pbs.sh"
hard_mask_path="/nobackup/zcsu_research/npy/cistrom/hard_mask.py"
batch_hard_mask_path="/nobackup/zcsu_research/npy/cistrom/batch_hard_mask.sh"
create_generate_background_markov_path="/nobackup/zcsu_research/npy/cistrom/create_generate_background_markov.sh"
split_small_patches_path="/nobackup/zcsu_research/npy/cistrom/split_small_patches.py"
run_prosampler_path="/nobackup/zcsu_research/npy/cistrom/run_prosampler.sh"                     
script_convert_bed_fasta="/nobackup/zcsu_research/npy/cistrom/convert_bed_fasta.sh"
#prosampler_path="/nobackup/zcsu_research/npy/cistrom/ProSampler"

script_get_peaknumber="/nobackup/zcsu_research/npy/cistrom/count_sequence_number.sh"
script_get_peaklength="/nobackup/zcsu_research/npy/cistrom/count_peak_length.sh"
script_get_motifnumber="/nobackup/zcsu_research/npy/cistrom/count_motif_number.sh"


script_get_overlap_tf_pair="/nobackup/zcsu_research/npy/cistrom/compute_S0.sh"
script_paser_overlap_s0="/nobackup/zcsu_research/npy/cistrom/paser_S0.py"
script_count_exon_bp="/nobackup/zcsu_research/npy/cistrom/count_exon_total_bp.py"


bed_coding_exon="/nobackup/zcsu_research/npy/cistrom/Compute_Overlap_between_dataset_and_reference/human_hg38_exons_coding.chr.bed"
bed_exon="/nobackup/zcsu_research/npy/cistrom/Compute_Overlap_between_dataset_and_reference/human_hg38_exons.bed"


script_plot_s0="/nobackup/zcsu_research/npy/cistrom/plot_S0.py"
script_paser_sites="/nobackup/zcsu_research/npy/cistrom/paser_site_to_bed.py"
script_convert_site_bed_to_fa="/nobackup/zcsu_research/npy/cistrom/convert_site_bed_to_fa.sh"
hg38_fa="/nobackup/zcsu_research/npy/cistrom/reference/hg38.fa"

script_cat_site_bed_cluster="/nobackup/zcsu_research/npy/cistrom/cat_site_bed_cluster.py"
script_sort_and_merge_sites_bed_cluster="/nobackup/zcsu_research/npy/cistrom/sort_and_merge_sites_bed_cluster.sh"
script_paser_meme="/nobackup/zcsu_research/npy/cistrom/paser_prosampler_single.py"
script_plot_logo="/nobackup/zcsu_research/npy/cistrom/genLogo.R"
script_sort_and_merge_sites_bed="/nobackup/zcsu_research/npy/cistrom/sort_and_merge_sites_bed_cluster.sh"
script_remove_repeat_peak="/nobackup/zcsu_research/npy/cistrom/filter_binding_sites.py"
script_map_binding_sites_to_original_peak="/nobackup/zcsu_research/npy/cistrom/map_binding_sites_to_original_peak.py"
script_convert_gt_2_to_origin_peak_bed="/nobackup/zcsu_research/npy/cistrom/convert_gt_2_to_origin_peak_bed.py"
script_umotif_origin_peak_overlap="/nobackup/zcsu_research/npy/cistrom/umotif_origin_peak_overlap.sh"

script_paser_overlap_s0="/nobackup/zcsu_research/npy/cistrom/paser_S0.py"
script_plot_s0="/nobackup/zcsu_research/npy/cistrom/plot_S0.py"

function paser_meme_for_cluster(){

    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder} 


	cp ${script_paser_meme} .
	pbs="header_run_paser_meme_"${cluster_folder}"_"${t_value}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler_single.py ${cluster_folder}.${t_value}.meme" >> ${pbs}
	qsub ${pbs}

	cd ../
    done
}

function paser_meme_for_rest_cluster(){

    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder} 

	paser_folder=${cluster_folder}"."${t_value}"_motif"
	cp ${script_paser_meme} .
	umotif_0=${paser_folder}"/"${cluster_folder}"."${t_value}"_0.meme.meme"
	
	if [[ ! -f ${umotif_0} ]];then
	    pbs="header_re_run_paser_meme_"${cluster_folder}"_"${t_value}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_folder}.${t_value}.meme" >> ${pbs}
	    qsub ${pbs}
	fi

	cd ../
    done
}

function sort_extend_peak () {

    pbs=sort_extend_bed.pbs
    echo -e $pbs_header > $pbs
    echo -e "bash sort_extend_bed.sh">> $pbs
    qsub $pbs
}

function convert_bed_to_fasta(){

    ref_genome=${hg38_fa}
    files=*_sort.bed

    if [[ -f run_convert_bed_to_fasta.sh ]];then
	rm -f run_convert_bed_to_fasta.sh
    fi
    
    for f in $files
    do
	
	echo -e "bedtools getfasta -fi $ref_genome -bed $f -fo ${f}.fa" >> run_convert_bed_to_fasta.sh
    done

    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.sh" run_convert_bed_to_fasta.sh small_patch_convert_to_fasta_

    files=small_patch_convert_to_fasta_*_index.sh
    for batch in ${files}
    do
	pbs="run_batch_convert_bed_"${batch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash ${batch}" >> ${pbs}
	more ${pbs}
    done
}

function submit_convert_fasta_batch(){
    files=small_patch_convert_to_fasta_*_index.sh
    for batch in ${files}
    do
	pbs="run_batch_convert_bed_"${batch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash ${batch}" >> ${pbs}
	qsub ${pbs}
    done

}


function check_un_finished_convert_fasta_batch(){
    files=small_patch_convert_to_fasta_*_index.sh
    for batch in ${files}
    do
	pbs="run_batch_convert_bed_"${batch}".pbs"
	error=(${pbs}.e*)

	if [[ ! -f ${error} ]];then
	    qsub ${pbs}
	fi

    done

}


function create_hard_mask_pbs () {


    cp ${hard_mask_path} .
    cp ${batch_hard_mask_path} .

    
    if [[ ! -d Hard_Fasta_File ]]
    then
	mkdir Hard_Fasta_File
    fi

    pbses=$(ls *.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm *.pbs
    fi

    rm small_patch_*

    ls *_sort.bed.fa > file_name_index
    split -l 20 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_fasta_
    
    small_patch_files=small_patch_fasta*
    for s in $small_patch_files
    do
	pbs=${s}.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash batch_hard_mask.sh $s" >> $pbs
	qsub $pbs
    done

}


function create_background_pbs () {

    cp ${create_generate_background_markov_path} .
    cp ${split_small_patches_path} .

    #rm *markov.bg
    pbses=$(ls *.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm *.pbs
    fi


    rm small_patch_*

    ls *.fa.hard > file_name_index
    #python split_small_patches.py file_name_index 700 small_patch
    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_fasta_
    
    small_patch_files=small_patch*
    for s in $small_patch_files
    do
	pbs=${s}.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash create_generate_background_markov.sh $s" >> $pbs
	qsub $pbs
    done
}


function create_run_prosampler_pbs () {


    cp ${run_prosampler_path} .
    #cp ${prosampler_path} .
    #chmod 777 ProSampler
    #rm ProSampler

    pbses=$(ls *run_prosampler.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm -f *run_prosampler.pbs*
    fi
    
    #rm small_patch_*

    #du *.fa.hard > file_name_index
    #python split_small_patches.py file_name_index 700 small_patch
    
    ls *.fa.hard > file_name_index
    #python split_small_patches.py file_name_index 700 small_patch
    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_prosampler_

    small_patch_files=small_patch_prosampler_*
    for s in $small_patch_files
    do
	pbs=${s}.run_prosampler.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash run_prosampler.sh $s" >> $pbs
	qsub $pbs
    done
}


function check_un_run_prosampler {
    #rm run_single_*_prosampler.pbs

    
    fa_files=*.fa.hard

    for f in $fa_files
    do
	if [[ ! -f ${f}.prosampler.txt.site ]];then

	    output=${f}.prosampler.txt

	    pbs="run_single_"${f}"_prosampler.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "time ProSampler -i ${f} -b ${f}.markov.bg -o ${output}" >> ${pbs}
	    qsub ${pbs}

	fi
    done
}




function run_compute_overlap(){
    #cp ${count_overlap_script} .

    index=0
    
    bed_files=*.bed
    for bed in ${bed_files}
    do
	pbs="run_compute_overlap_"${bed}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_S0.sh ${bed}" >> ${pbs}
	more ${pbs}
	((index++))

	mode=$((${index}%500))

	if [[ ${mode} -eq 0 ]];then
	    echo "sleep 30m"
	fi
    done
}


function run_check_compute_overlap(){
    #cp ${count_overlap_script} .

    bed_files=*.bed
    for bed in ${bed_files}
    do
	pbs="run_compute_overlap_"${bed}".pbs"

	output=${bed}".overlap_with_others.txt"

	if [[ ! -f ${output} ]];then
	    qsub ${pbs}
	fi
    done
}



function run_paser_s0(){
    cp ${script_paser_overlap_s0} .
    peak_number_name="TF_human_filter_unmerge_peak_1000_number.txt"
    pbs="run_paser_s0.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python paser_S0.py ${peak_number_name}" >> ${pbs}
    qsub ${pbs}

}

function run_plot_s0(){
    cp ${script_plot_s0} .
    pbs="run_plot_s0.pbs"
    csv_name="TF_human_filter_unmerge_peak_1000_number.matrix.csv"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_S0.py ${csv_name}" >> ${pbs}
    qsub ${pbs}
    #python plot_S0.py ${csv_name}
}


for folder in $human_fa_folder #$mouse_fa_folder
do

    #dist_folder_root="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/"

    cd ${folder}
    #output="TF_human_filter_pool_peak_unextend_number.txt"
    #count_tf_peak_number ${output}
    #cp ${output} /nobackup/zcsu_research/npy/cistrom/reference
    #output="TF_human_filter_pool_peak_unextend_peak_length.txt"
    #cp ${output} /nobackup/zcsu_research/npy/cistrom/reference

    #count_tf_dataset_peak_length ${output}
    

    for length in 1000 #1500 #3000
    do
	extend_folder="extend_to_"${length}
	cp ${sort_extend_peak_path} ${extend_folder}
	cd ${extend_folder}
	#sort_extend_peak
	
	cd Sorted_Bed
	#run_compute_overlap
	#run_check_compute_overlap
	#run_paser_s0
	#run_plot_s0
	
	#convert_bed_to_fasta
	#submit_convert_fasta_batch
	#ls *.fa|wc -l
	#check_un_finished__convert_fasta_batch

	#cp ${hard_mask_path} Fasta_File
	#cp ${batch_hard_mask_path} Fasta_File

	#mkdir Fasta_File
	#mv *.fa Fasta_File

	cd Fasta_File
	#create_hard_mask_pbs

	cd Hard_Fasta_File/
	#create_background_pbs
	#ls *.fa.hard|wc -l
	#ls *.markov.bg|wc -l
	#echo "---------------"
	#create_run_prosampler_pbs
	#ls *.site|wc -l

	#check_un_run_prosampler
	

	#mkdir MOTIFS
	#mv *.site MOTIFS
	#mv *.meme MOTIFS
	#mv *.spic MOTIFS
	#cp small_patch* MOTIFS
	#cd MOTIFS
	#output="TF_human_filter_pool_peak_"${length}"_motif_number.txt"
	#cp ${output} /nobackup/zcsu_research/npy/cistrom/reference
	#count_tf_dataset_motif_number ${output}
	#cp *_motif_number.txt /nobackup/zcsu_research/npy/cistrom/reference


	########################################################
	#cd MOTIF_U_SITES_GT_0.7_FOLDER
	#convert_sites_bed_patch	
	#pwd
	#cd ../
	#######################################################
	

	################################################################


	#cat_site_bed_to_cluster
	#sort_merge_fasta_bg
	#sort_merge_fasta_bg_rest
	#run_prosampler_l0_cluster 8
	#run_prosampler_l0_rest_cluster 8
	#run_prosampler_l0_cluster 6
	#run_prosampler_l0_rest_cluster 6

	#run_prosampler_l0_cluster 8
	#run_prosampler_l0_rest_cluster 6



	#-----------------------------------------------------------
	#paser_meme_for_cluster 8
	#paser_meme_for_rest_cluster 8

	#paser_meme_for_cluster 6
	#paser_meme_for_rest_cluster 6
	#-----------------------------------------------------------



	cd ../
	cd ../
	cd ../
	cd ../
    done
    cd ${current_working_folder}
done
