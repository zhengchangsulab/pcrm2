#!/bin/bash

human_fa_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder"
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
hg38_fa="/nobackup/zcsu_research/npy/reference/hg38.fa"

script_cat_site_bed_cluster="/nobackup/zcsu_research/npy/cistrom/cat_site_bed_cluster.py"
script_sort_and_merge_sites_bed_cluster="/nobackup/zcsu_research/npy/cistrom/sort_and_merge_sites_bed_cluster.sh"
script_paser_meme="/nobackup/zcsu_research/npy/cistrom/paser_prosampler_single.py"
script_plot_logo="/nobackup/zcsu_research/npy/cistrom/genLogo.R"
script_sort_and_merge_sites_bed="/nobackup/zcsu_research/npy/cistrom/sort_and_merge_sites_bed_cluster.sh"
script_remove_repeat_peak="/nobackup/zcsu_research/npy/cistrom/filter_binding_sites.py"
script_map_binding_sites_to_original_peak="/nobackup/zcsu_research/npy/cistrom/map_binding_sites_to_original_peak.py"
script_convert_gt_2_to_origin_peak_bed="/nobackup/zcsu_research/npy/cistrom/convert_gt_2_to_origin_peak_bed.py"


function sort_merge_sites_bed_cluster_1(){
    
    bed_file=$1
    pbs="re_run_merge_"${bed_file}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash sort_and_merge_sites_bed_cluster.sh ${bed_file}" >> ${pbs}
    qsub ${pbs}
}


function remove_repeat_peak_umotif_merge_cluster_1(){

    cluster_merge=$1

    pbs="run_remove_repeat_peak_umotif_"${cluster_merge}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python filter_binding_sites.py ${cluster_merge}" >> ${pbs}
    qsub ${pbs}

}


function run_map_binding_site_to_origin_cluster_1(){

    t_value=$1
    cluster_clean_file=$2
    
    cluster_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_1500/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_30/UMOTIF_FOR_ALL_CLUSTER/CLUSTER_BED_MERGE/"

    ext_name="."${t_value}"_0.sites.bed.sort.merge.clean"

	
    cluster_name=${cluster_clean_file/${ext_name}/}
    cluster_path=${cluster_folder}${cluster_name}".bed.sort.merge.clean"
    
    mem=256GB
    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
    pbs="run_convert_sites_to_origin_peak_"${cluster_clean_file}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python map_binding_sites_to_original_peak.py ${cluster_path} ${cluster_clean_file}" >> ${pbs}
    qsub ${pbs}

}

function run_filter_binding_sites_mt_2_peaks_cluster_1(){
    f=$1
    pbs="run_filter_origin_file_"${f}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "more ${f}|grep \",\" > ${f}.gt_2" >> ${pbs}
    qsub ${pbs}

}


function run_filter_binding_sites_mt_2_rest_peaks(){
    files=*.origin
    for f in ${files}
    do
	if [[ ! -f ${f}".gt_2" ]];then
	    pbs="run_filter_origin_file_"${f}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "more ${f}|grep \",\" > ${f}.gt_2" >> ${pbs}
	    qsub ${pbs}
	fi
    done
}


function run_script_convert_gt_2_to_origin_peak_bed_cluster_1(){

    gt_2_file=$1
    pbs="run_script_convert_gt_2_to_origin_peak_bed_"${gt_2_file}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python convert_gt_2_to_origin_peak_bed.py ${gt_2_file}" >> ${pbs}
    qsub ${pbs}
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


    for length in 1500 #1000 1500 3000
    do
	extend_folder="extend_to_"${length}
	cp ${sort_extend_peak_path} ${extend_folder}
	cd ${extend_folder}
	#sort_extend_peak
	
	cd Sorted_Bed
	#move_none_pool_to_pool ${length}
	
	#output="TF_human_filter_pool_peak_"${length}"_number.txt"
	#count_tf_peak_number ${output}
	#run_find_overlap_tf_pair

	#run_rest_find_overlap_tf_pair

	#run_find_overlap_with_exon
	#run_find_rest_overlap_with_exon

	#cat_merge_all ${length}
	#keep_3_field_sort ${length}
	#bedtools_merge_all ${length}

	#rm *overlap_with_exon
	#cat_merge_exon ${length}
	#keep_3_field_sort_exon ${length}
	#bedtools_merge_exon ${length}

	
	#all_merge_overlap_with_coding_exon ${length}
	#cp ${hard_mask_path} Fasta_File
	#cp ${batch_hard_mask_path} Fasta_File


	#run_count_exon_bp TF_all_sort_motifs.${length}.bed.cat.sort.clean.merge.overlap_with_coding_exon
	#run_count_exon_bp TF_all_sort_motifs.${length}.bed.coding_exon.cat.sort.clean.merge
	#cp *.count_bp /nobackup/zcsu_research/npy/cistrom/reference
	
	#run_paser_s0 ${length}
	
	#run_plot_s0 ${length}

	cd Fasta_File
	#create_hard_mask_pbs
	cd Hard_Fasta_File/
	#create_run_prosampler_pbs
	#mkdir MOTIFS
	#mv *.site MOTIFS
	#mv *.meme MOTIFS
	#mv *.spic MOTIFS
	#cp small_patch* MOTIFS
	cd MOTIFS
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
	cd MOTIF_U_PSM_GT_0.7_SPIC_FOLDER
	cd Cluster_Inflation_30/


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

	#-----------------------------------------------------------
	#plot_meme_logo 8
	#plot_meme_logo 6
	#-----------------------------------------------------------


	
	#-------------------------------------------------------------------
	#
	cd UMOTIF_FOR_ALL_CLUSTER_6/UMOTIF_SITES/UMOTIF_BED/UMOTIF_BED_MERGE/UMOTIF_BED_MERGE_CLEAN/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2
	#convert_sites_bed_patch
	#mkdir UMOTIF_BED
	#mv *.bed UMOTIF_BED
	####cd UMOTIF_BED
	#sort_merge_sites_bed
	#sort_merge_sites_bed_rest
	#sort_merge_sites_bed_cluster_1 cluster_1.6_0.sites.bed
	#remove_repeat_peak_umotif_merge_cluster_1 cluster_1.6_0.sites.bed.sort.merge
	#run_map_binding_site_to_origin_cluster_1 6 cluster_1.6_0.sites.bed.sort.merge.clean
	#run_filter_binding_sites_mt_2_peaks_cluster_1 cluster_1.6_0.sites.bed.sort.merge.clean.origin
	run_script_convert_gt_2_to_origin_peak_bed_cluster_1 cluster_1.6_0.sites.bed.sort.merge.clean.origin.gt_2

	#mkdir UMOTIF_BED_MERGE
	#mv *sites.bed.sort.merge UMOTIF_BED_MERGE 
	#####cd UMOTIF_BED_MERGE
	#remove_repeat_peak_umotif_rest_merge
	#mkdir UMOTIF_BED_MERGE_CLEAN
	#mv *.clean UMOTIF_BED_MERGE_CLEAN
	#run_map_binding_site_to_origin 6
	#run_map_binding_site_to_rest_origin 6
	#run_filter_binding_sites_mt_2_peaks
	#run_filter_binding_sites_mt_2_rest_peaks
	#run_script_convert_gt_2_to_origin_peak_bed
	#run_script_convert_gt_2_to_rest_origin_peak_bed
	
	cd ../../../../../../


	cd UMOTIF_FOR_ALL_CLUSTER_8/UMOTIF_SITES/UMOTIF_BED/UMOTIF_BED_MERGE/UMOTIF_BED_MERGE_CLEAN/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2
	#convert_sites_bed_patch
	#mkdir UMOTIF_BED
	#mv *.bed UMOTIF_BED

	####cd UMOTIF_BED
	#sort_merge_sites_bed
	#sort_merge_sites_bed_rest
	#sort_merge_sites_bed_cluster_1 cluster_1.8_0.sites.bed
	#cluster_1.6_0.sites.bed
	#remove_repeat_peak_umotif_merge_cluster_1 cluster_1.8_0.sites.bed.sort.merge
	#run_map_binding_site_to_origin_cluster_1 8 cluster_1.8_0.sites.bed.sort.merge.clean
	#run_filter_binding_sites_mt_2_peaks_cluster_1 cluster_1.8_0.sites.bed.sort.merge.clean.origin
	run_script_convert_gt_2_to_origin_peak_bed_cluster_1 cluster_1.8_0.sites.bed.sort.merge.clean.origin.gt_2

	#mkdir UMOTIF_BED_MERGE
	#mv *sites.bed.sort.merge UMOTIF_BED_MERGE 
	####cd UMOTIF_BED_MERGE
	#remove_repeat_peak_umotif_rest_merge
	#mkdir UMOTIF_BED_MERGE_CLEAN
	#mv *.clean UMOTIF_BED_MERGE_CLEAN
	#run_map_binding_site_to_origin 8
	#run_map_binding_site_to_rest_origin 8
	#run_filter_binding_sites_mt_2_peaks
	#run_filter_binding_sites_mt_2_rest_peaks
	#run_script_convert_gt_2_to_origin_peak_bed
	#run_script_convert_gt_2_to_rest_origin_peak_bed
	cd ../../../../../../
	#cd UMOTIF_BED/
	#sort_merge_sites_bed
	#cd UMOTIF_BED_MERGE/
	#remove_repeat_peak_umotif_merge
	#cd ../
	#cd ../
	#cd ../../
	#-------------------------------------------------------------------



	#-------------------------------------------------------------------
	#cd UMOTIF_FOR_ALL_CLUSTER/UMOTIF_BED/
	#sort_merge_sites_bed
	#cd ../../
	#-------------------------------------------------------------------

	cd ../
	cd ../
	################################################################

	cd ../

	#create_background_pbs
	#check_unrun_background
	#dist_folder=${dist_folder_root}${extend_folder}"/Sorted_Bed/Fasta_File/Hard_Fasta_File"
	#cp *_sort.bed.fa.hard ${dist_folder}
	#cp *_sort.bed.fa.hard.markov.bg ${dist_folder}
	#echo ${dist_folder}
	cd ../
	cd ../
	cd ../
	cd ../
    done
    cd ${current_working_folder}
done
