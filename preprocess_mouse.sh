#!/bin/bash
mouse_fa_folder="/nobackup/zcsu_research/npy/cistrom/TF_mouse/TF_mouse_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder"

current_working_folder="/nobackup/zcsu_research/npy/cistrom/"
extend_peak_path="/nobackup/zcsu_research/npy/cistrom/extend_peaks.py"
extend_all_peaks_path="/nobackup/zcsu_research/npy/cistrom/extent_all_files.sh"
sort_extend_peak_path="/nobackup/zcsu_research/npy/cistrom/sort_extend_bed.sh"
convert_bed_to_fasta_path="/nobackup/zcsu_research/npy/cistrom/convert_bed_fasta.sh"
hard_mask_path="/nobackup/zcsu_research/npy/cistrom/hard_mask.py"
paser_prosampler_path="/nobackup/zcsu_research/npy/cistrom/paser_prosampler_single.py"
compute_sc_score_path="/nobackup/zcsu_research/npy/cistrom/compute_Sc_v0.3.py"
plot_sc_path="/nobackup/zcsu_research/npy/cistrom/plot_Sc_dist.py"
build_keep_motif_dataset_path="/nobackup/zcsu_research/npy/cistrom/build_keep_motif_dataset.sh"
paser_site_to_bed_path="/nobackup/zcsu_research/npy/cistrom/paser_site_to_bed.py"


mm10_fa="/nobackup/zcsu_research/npy/cistrom/reference/mm10.fa"
mm10_size="/nobackup/zcsu_research/npy/cistrom/reference/mm10.chrom.sizes"

function convert_site_to_sitebed(){
    cd MOTIF_U_SITES_GT_0.7_FOLDER
    cp ${paser_site_to_bed_path} .
    #ls *.sites > file_all_sites
    #split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" file_all_sites small_patch_motif_site_

    #mkdir SITES_BED

    small_patches=small_patch_motif_site_*index.txt
    for small_patch in ${small_patches}
    do
	pbs="run_convert_bed_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_site_to_bed.py ${small_patch} 0" >> ${pbs}
	qsub ${pbs}
    done
    
    cd ../
}


for folder in $mouse_fa_folder
do
    #cp ${extend_peak_path} ${folder}
    #cp ${extend_all_peaks_path} ${folder}
    cd ${folder}

    
    
    for length in 1500
    do
	
	extend_folder="extend_to_"${length}
	#run_extend_all_peaks ${length} ${mm10_size} ${extend_folder}
	cd ${extend_folder}
	#run_sort_extend_peak
	cd Sorted_Bed
	#run_convert_bed_to_fasta
	#mv *.fa Fasta_File
	cd Fasta_File
	#create_hard_mask_pbs
	#mkdir Hard_Fasta_File/
	#mv *.hard Hard_Fasta_File/
	cd Hard_Fasta_File/
	#run_get_background_pbs
	#rerun_un_run_background_pbs
	#run_prosampler_pbs
	#check_unrun_prosampler_pbs
	#mkdir MOTIFS
	#mv *.site MOTIFS
	#mv *.meme MOTIFS
	#mv *.spic MOTIFS
	cd MOTIFS
	#run_paser_prosampler
	#check_un_paser_prosampler
	#run_compute_sc_score
	#run_count_motifs
	#run_get_tf_index_gt_2_motif
	#run_cat_sc_score_into_total
	#run_plot_sc
	#run_keep_Sc_gt_than_threshold
	#run_build_keep_motif_dataset
	#run_copy_spic_to_group
	#convert_site_to_sitebed
	
    done
    cd ${current_working_folder}
done
