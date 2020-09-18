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
mm10_fa="/nobackup/zcsu_research/npy/cistrom/reference/mm10.fa"
mm10_size="/nobackup/zcsu_research/npy/cistrom/reference/mm10.chrom.sizes"

script_extend_peaks="/nobackup/zcsu_research/npy/cistrom/extend_peaks.py"
script_extend_all_data="/nobackup/zcsu_research/npy/cistrom/extent_all_files.sh"

script_cat_site_bed_cluster="/nobackup/zcsu_research/npy/cistrom/cat_site_bed_cluster.py"
script_sort_and_merge_sites_bed_cluster="/nobackup/zcsu_research/npy/cistrom/sort_and_merge_sites_bed_cluster.sh"
script_paser_meme="/nobackup/zcsu_research/npy/cistrom/paser_prosampler_single.py"
script_paser_meme_batch="/nobackup/zcsu_research/npy/cistrom/paser_prosampler.py"



script_plot_logo="/nobackup/zcsu_research/npy/cistrom/genLogo.R"
script_sort_and_merge_sites_bed="/nobackup/zcsu_research/npy/cistrom/sort_and_merge_sites_bed_cluster.sh"
script_remove_repeat_peak="/nobackup/zcsu_research/npy/cistrom/filter_binding_sites.py"
script_map_binding_sites_to_original_peak="/nobackup/zcsu_research/npy/cistrom/map_binding_sites_to_original_peak.py"
script_convert_gt_2_to_origin_peak_bed="/nobackup/zcsu_research/npy/cistrom/convert_gt_2_to_origin_peak_bed.py"
script_umotif_origin_peak_overlap="/nobackup/zcsu_research/npy/cistrom/umotif_origin_peak_overlap.sh"
compute_sc_score_path="/nobackup/zcsu_research/npy/cistrom/compute_Sc_v0.3.py"
plot_dist_path="/nobackup/zcsu_research/npy/cistrom/plot_Sc_dist.py"
build_keep_motif_dataset_script="/nobackup/zcsu_research/npy/cistrom/build_keep_motif_dataset.sh"
count_motifs_script="/nobackup/zcsu_research/npy/cistrom/count_motifs.sh"
build_keep_motif_dataset_script="/nobackup/zcsu_research/npy/cistrom/build_keep_motif_dataset.sh"
modify_header_spic_path="/nobackup/zcsu_research/npy/cistrom/modify_header_spic.py"
paser_spic_path="/nobackup/zcsu_research/npy/cistrom/paser_spic.py"
compute_spic_path="/nobackup/zcsu_research/npy/cistrom/compute_spic.sh"


function run_extend_peaks(){
    length=$1
    ref_size=$2
    extend_folder=$3
    cp ${script_extend_all_data} .
    cp ${script_extend_peaks} .
    pbs="run_extend_all_peaks.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash extent_all_files.sh ${length} ${ref_size} ${extend_folder}" >> ${pbs}
    qsub ${pbs}
}


function sort_extend_peak () {
    cp ${sort_extend_peak_path} .
    pbs=sort_extend_bed.pbs
    echo -e $pbs_header > $pbs
    echo -e "bash sort_extend_bed.sh">> $pbs
    qsub $pbs
}

function convert_bed_to_fasta(){

    ref_genome=${mm10_fa}
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
	qsub ${pbs}
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
    cp ${script_paser_meme} .

    index=0
    meme_files=*.meme

    for meme in ${meme_files}
    do
	pbs="run_paser_"${meme}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler_single.py ${meme}" >> ${pbs}
	qsub ${pbs}

	((index ++))

	flag=$((index % 1000))

	if [[ ${flag} -eq 0 ]];then
	    sleep 10m

	fi
    done
}

function run_paser_prosampler_batch(){

    cp ${script_paser_meme_batch} .
    
    ls *.meme > file_name_index
    split -l 50 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_meme_

    small_patch_files=small_patch_meme*

    for s in ${small_patch_files}
    do
	pbs="run_paser_"${s}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler.py ${s}" >> ${pbs}
	qsub ${pbs}
    done
}


function run_compute_sc_score(){
    cp ${compute_sc_score_path} .
    meme_files=*fa.hard.prosampler.txt.meme

    index=0

    for meme in ${meme_files}
    do
	tf_index=${meme%%_*}
	pbs="run_compute_sc_"${tf_index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_Sc_v0.3.py ${tf_index}" >> ${pbs}
	qsub ${pbs}

	((index ++))

	flag=$((index % 1000))

	if [[ ${flag} -eq 0 ]];then
	    sleep 5m

	fi
    done
}



function check_run_compute_sc_score(){
    cp ${compute_sc_score_path} .
    meme_files=*fa.hard.prosampler.txt.meme


    for meme in ${meme_files}
    do
	tf_index=${meme%%_*}
	Sc_score="Sc_Score_"${tf_index}".u.txt"

	pbs="run_compute_sc_"${tf_index}".pbs"
	if [[ ! -f ${Sc_score} ]];then
	    qsub ${pbs}

	fi
    done
}


function run_plot_sc_dist(){

    cp ${plot_dist_path} .
    cat Sc_Score_*.u.txt > Sc_score_mouse_1000.u.total.txt

    pbs="run_plot_sc_hist.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_Sc_dist.py Sc_score_mouse_1000.u.total.txt" >> ${pbs}
    qsub ${pbs}
}

function run_build_keep_motif_dataset(){
    cp ${build_keep_motif_dataset_script} .
    pbs="run_build_keep_motif_script.u.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_keep_motif_dataset.sh Sc_score_mouse_1000.u.total_0.7.keep_motif.txt" >> ${pbs}
    qsub ${pbs}
}

function run_count_motif_number(){
    cp ${count_motifs_script} .

    pbs="run_counts_motif.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_motifs.sh" >> ${pbs}
    qsub ${pbs}
}


function run_build_keep_motif_dataset(){
    cp ${build_keep_motif_dataset_script} .
    pbs="run_build_keep_motif_script.u.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_keep_motif_dataset.sh Sc_score_mouse_1000.u.total_0.7.keep_motif.txt" >> ${pbs}
    qsub ${pbs}
}

function run_modify_spic_header(){
    cp ${modify_header_spic_path} .

    pbs="run_modify_spic.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python modify_header_spic.py" >> ${pbs}
    qsub ${pbs}
}



function run_paser_spic(){
    cp ${paser_spic_path} .

    pbs="run_paser_spic.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python paser_spic.py" >> ${pbs}
    qsub ${pbs}
}

function run_compute_spic(){

    cp ${compute_spic_path} .
    
    ls *.spic > file_name_index
    split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" file_name_index small_patch_spic_

    small_patch_files=small_patch_spic*

    for s in ${small_patch_files}
    do
	pbs="run_compute_spic_"${s}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_spic.sh ${s}" >> ${pbs}
	echo ${pbs}
    done
}

for folder in $mouse_fa_folder #$human_fa_folder #$mouse_fa_folder
do

    #dist_folder_root="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/"

    cd ${folder}
    #output="TF_human_filter_pool_peak_unextend_number.txt"
    #count_tf_peak_number ${output}
    #cp ${output} /nobackup/zcsu_research/npy/cistrom/reference
    #output="TF_human_filter_pool_peak_unextend_peak_length.txt"
    #cp ${output} /nobackup/zcsu_research/npy/cistrom/reference

    #count_tf_dataset_peak_length ${output}
    #ls *.bed|wc -l

    for length in 1000 #1500 #3000
    do
	extend_folder="extend_to_"${length}

	#run_extend_peaks ${length} ${mm10_size} ${extend_folder}

	#cp ${sort_extend_peak_path} ${extend_folder}
	

	cd ${extend_folder}
	#sort_extend_peak
	cd Sorted_Bed/

	#convert_bed_to_fasta
	#submit_convert_fasta_batch
	#ls *.fa|wc -l
	#check_un_finished_convert_fasta_batch

	#cp ${hard_mask_path} Fasta_File
	#cp ${batch_hard_mask_path} Fasta_File

	#mkdir Fasta_File
	#mv *.fa Fasta_File

	cd Fasta_File/
	#ls *fa|wc -l
	#create_hard_mask_pbs
	
	cd Hard_Fasta_File/
	#create_background_pbs
	#ls *.fa.hard|wc -l
	#ls *.markov.bg|wc -l
	#echo "---------------"
	#create_run_prosampler_pbs
	#run_prosampler_pbs
	
	#ls *.site|wc -l

	#check_un_run_prosampler
	#check_unrun_prosampler_pbs   

	#mkdir MOTIFS
	#mv *.site MOTIFS
	#mv *.meme MOTIFS
	#mv *.spic MOTIFS
	#cp small_patch* MOTIFS
	#
	cd MOTIFS

	#run_paser_prosampler
	#run_paser_prosampler_batch
	#ls *.meme|wc -l
	#ls -d *_motif|wc -l
	
	#output="TF_human_filter_pool_peak_"${length}"_motif_number.txt"
	#cp ${output} /nobackup/zcsu_research/npy/cistrom/reference
	#count_tf_dataset_motif_number ${output}
	#cp *_motif_number.txt /nobackup/zcsu_research/npy/cistrom/reference

	#run_compute_sc_score
	#check_run_compute_sc_score


	#run_plot_sc_dist
	#run_count_motif_number

	#run_build_keep_motif_dataset
	########################################################
	#cd MOTIF_U_SITES_GT_0.7_FOLDER
	cd MOTIF_U_PSM_GT_0.7_SPIC_FOLDER
	#run_modify_spic_header
	#run_paser_spic
	run_compute_spic
	
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
