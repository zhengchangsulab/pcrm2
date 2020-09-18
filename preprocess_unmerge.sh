#!/bin/bash


script_paser_prosampler_path="/nobackup/zcsu_research/npy/cistrom/paser_prosampler.py"
cwd="/nobackup/zcsu_research/npy/cistrom"

folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/"


compute_sc_score_path="/nobackup/zcsu_research/npy/cistrom/compute_Sc_v0.3.py"
plot_dist_path="/nobackup/zcsu_research/npy/cistrom/plot_Sc_dist.py"
count_motif_number_script="/nobackup/zcsu_research/npy/cistrom/count_motif_number.sh"
count_motifs_script="/nobackup/zcsu_research/npy/cistrom/count_motifs.sh"
build_keep_motif_dataset_script="/nobackup/zcsu_research/npy/cistrom/build_keep_motif_dataset.sh"
modify_header_spic_path="/nobackup/zcsu_research/npy/cistrom/modify_header_spic.py"
paser_spic_path="/nobackup/zcsu_research/npy/cistrom/paser_spic.py"
compute_spic_path="/nobackup/zcsu_research/npy/cistrom/compute_spic.sh"


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
    
    #ls *.spic > file_name_index
    #split -l 100 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.txt" file_name_index small_patch_spic_

    small_patch_files=small_patch_spic*

    for s in ${small_patch_files}
    do
	pbs="run_compute_spic_"${s}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_spic.sh ${s}" >> ${pbs}
	qsub ${pbs}
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



cd ${folder}
for length in 1000 #1500
do
    extend_folder="extend_to_"${length}

    cd ${extend_folder}
    cd Sorted_Bed
    run_compute_overlap

    cd Fasta_File
    cd Hard_Fasta_File
    #move_meme_site_spic
    cd MOTIFS
    #run_paser_prosampler_batch
    #ls *.meme|wc -l
    #ls -d *_motif|wc -l
    #run_compute_sc_score
    #check_run_compute_sc_score
    #run_plot_sc_dist
    #run_count_motif_number
    #run_build_keep_motif_dataset
    cd MOTIF_U_PSM_GT_0.7_SPIC_FOLDER
    #run_modify_spic_header
    #run_paser_spic
    #run_compute_spic
    cd ../
    cd ../
    cd ../
    cd ../
    cd ../
    cd ../
done

cd ${cwd}
