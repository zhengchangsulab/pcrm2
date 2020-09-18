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
script_umotif_origin_peak_overlap="/nobackup/zcsu_research/npy/cistrom/umotif_origin_peak_overlap.sh"

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
	cd UMOTIF_FOR_ALL_CLUSTER_6/UMOTIF_SITES/UMOTIF_BED/UMOTIF_BED_MERGE/UMOTIF_BED_MERGE_CLEAN/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED_POS
	#convert_sites_bed_patch
	#mkdir UMOTIF_BED
	#mv *.bed UMOTIF_BED
	####cd UMOTIF_BED
	#sort_merge_sites_bed
	#sort_merge_sites_bed_rest
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
	#run_un_finished_script_convert_gt_2_to_rest_origin_peak_bed
	#mkdir UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED
	#mv *bed.sort.merge.clean.origin.gt_2.origin_bed UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED
	#run_script_umotif_origin_peak_overlap
	#run_rest_get_position
	#create_position_file_folder
	pwd
	cd ../../../../../../../../


	cd UMOTIF_FOR_ALL_CLUSTER_8/UMOTIF_SITES/UMOTIF_BED/UMOTIF_BED_MERGE/UMOTIF_BED_MERGE_CLEAN/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED/UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED_POS
	#convert_sites_bed_patch
	#mkdir UMOTIF_BED
	#mv *.bed UMOTIF_BED

	####cd UMOTIF_BED
	#sort_merge_sites_bed
	#sort_merge_sites_bed_rest
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
	#run_un_finished_script_convert_gt_2_to_rest_origin_peak_bed
	#mkdir UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED
	#mv *bed.sort.merge.clean.origin.gt_2.origin_bed UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED
	#run_script_umotif_origin_peak_overlap
	pwd
	#run_rest_get_position
	#create_position_file_folder
	cd ../../../../../../../../
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
