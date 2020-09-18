#!/bin/bash
s=$1

cwd_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"
extract_cre_sequences_script=${cwd_path}"/extract_cre_sequences.py"
compute_crm_score_v7_0_pair_script=${cwd_path}"/compute_crm_score_v7_0_pair.py"


function create_extract_cre_pbs(){
    extend=$1
    flag=$2
    cp ${extract_cre_sequences_script} .
    meme_bio_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO"


    
    all_crm="ALL_CRMs_"${i}
    seq_name=${all_crm}".crm.bed.clean.fa"

    small_patch_bed_files=small_patch*.bed
    for small_patch in ${small_patch_bed_files}
    do

	pbs="run_extract_cre_score"${small_patch}".pbs"
	seq_name=${small_patch}"."${extend}
	echo -e ${pbs_header} > ${pbs}	
	echo -e "python extract_cre_sequences.py ${seq_name} ${small_patch} ${meme_bio_path} ${flag}" >> ${pbs}
	qsub ${pbs}

    done

}



function compute_score(){
    network_name=$1
    flag=$2
    cp ${compute_crm_score_v7_0_pair_script} .
    small_patch_bed_files=small_patch*.bed
    for small_patch in ${small_patch_bed_files}
    do

	pbs="run_compute_crm_score"${small_patch}".pbs"
	seq_name=${small_patch}"."${extend}
	echo -e ${pbs_header} > ${pbs}	
	seq_name_score=${small_patch}"."${flag}".bed.fa.score"
	echo -e "python compute_crm_score_v7_0_pair.py ${seq_name_score} ${small_patch} MEAN ${network_name} ${flag}" >> ${pbs}
	qsub ${pbs}
    done
}



function run_extract_cre_score(){

    for i in 150 #300 #150 300 #150
    do
        folder="crm_"${i}
        cd ${folder}
	cd SMALL_PATCH_CRMS/
	#create_extract_cre_pbs "fa" "crm"
	compute_score "Umotif_Interaction_Score.txt" "crm"
        cd ../


	cd SMALL_PATCH_CRMS_Random/
	#create_extract_cre_pbs "fa.bg.fasta_peak_name" "random"
	compute_score "Umotif_Interaction_Score.txt.random" "random"
	cd ../
	cd ../
    done
}

run_extract_cre_score
