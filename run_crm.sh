#!/bin/bash                                                                                                                                                                                                                                   
cwd_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"

get_keep_tfbs_for_cluster_script=${cwd_path}"/get_keep_tfbs_for_cluster.py"
run_split_tfbs_script=${cwd_path}"/run_split_tfbs.sh"
convert_tfbs_format_v3_script=${cwd_path}"/convert_tfbs_format_v3.py"
run_convert_tfbs_format_split_script=${cwd_path}"/run_convert_tfbs_format_split.sh"
merge_keep_tfbs_script=${cwd_path}"/merge_keep_tfbs.py"
run_sort_uniq_script=${cwd_path}"/run_sort_uniq.sh"
run_merge_crm_script=${cwd_path}"/run_merge_crm.sh"
network_randomnize_script=${cwd_path}"/network_randomnize.py"
run_get_random_seq_script=${cwd_path}"/run_get_random_seq.sh"
change_peak_name_background_script=${cwd_path}"/change_peak_name_background.py"
extract_cre_sequences_script=${cwd_path}"/extract_cre_sequences.py"
compute_umotif_binding_score_script=${cwd_path}"/compute_umotif_binding_score.py"
compute_crm_score_v7_0_pair_script=${cwd_path}"/compute_crm_score_v7_0_pair.py"
compute_p_value_crm_v2_script=${cwd_path}"/compute_p_value_crm_v2.py"
run_random_and_crm_score_script=${cwd_path}"/run_random_and_crm_score.sh"
run_extract_cre_score_small_batch_script=${cwd_path}"/run_extract_cre_score_small_batch.sh"
compute_p_value_v2_script=${cwd_path}"/compute_p_value_v2.sh"


function run_convert_tfbs_split_overlap(){
    folders=cluster_*/
    for folder in ${folders}
    do
	cd ${folder}
	rm *.tfbs
	rm *.tfbs.dataset_info
	cp ${convert_tfbs_format_v3_script} .
	cp ${run_convert_tfbs_format_split_script} .
	pbs="run_convert_tfbs_format_split.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_convert_tfbs_format_split.sh" >> ${pbs}
	qsub ${pbs}
	cd ../
    done

}


function run_get_keep_tfbs_for_cluster(){
    origin_peak=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    cutoff=0.2
    cp ${get_keep_tfbs_for_cluster_script} .
    cp ${run_split_tfbs_script} .
    for origin in ${origin_peak}
    do
        cluster_index=${origin/".30.8.8_0.sites.bed.origin.origin_peak"/}
        keep_tfbs_name=${cluster_index}".KEEP_TFBS"

        pbs="run_get_keep_tfbs_"${cluster_index}".pbs"
        echo -e ${pbs_header} > ${pbs}
        echo -e "python get_keep_tfbs_for_cluster.py ${cluster_index} ${cutoff}" >> ${pbs}
        #echo -e "bash run_split_tfbs.sh ${keep_tfbs_name} ${cutoff}" >> ${pbs}
        qsub ${pbs}
	#python get_keep_tfbs_for_cluster.py ${cluster_index} ${cutoff}
	#echo ${cluster_index}
    done
}

function run_merge(){
    #mkdir -p Merge_CRM_Norm/
    cp ${merge_keep_tfbs_script} .
    pbs="run_merge_tfbs.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python merge_keep_tfbs.py" >> ${pbs}
    qsub ${pbs}


}

function run_split_chr(){
    pbs="run_split_crm.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "awk '{print \$0 >> \$1\"_KEEP_BINDING_SITES.bed\"}' TOTAL_KEEP_BINDING_SITES_Norm.bed" >> ${pbs}
    qsub ${pbs}
}

function sort_uniq(){
    cp ${run_sort_uniq_script} .
    bash run_sort_uniq.sh
}


function run_merge_crm(){
    cp ${run_merge_crm_script} .
    bash run_merge_crm.sh
}



function run_cat_merge_crm(){
    for i in 150 300
    do
	folder="crm_"${i}
	cd ${folder}
	pbs="pbs_cat_all_crm.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "cat chr*KEEP_BINDING_SITES.bed.sort.uniq.*.crm > ALL_CRMs_"${i} >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}

function run_randomize_network(){
    cp ${network_randomnize_script} .
    pbs="run_randomnize_network.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python network_randomnize.py Umotif_Interaction_Score.txt" >> ${pbs}
    qsub ${pbs}
}


function move_meme_bio(){
    s=$1
    cp -r "/nobackup/zcsu_research/npy/All_In_One_CRM_Project/"${s}"_factor/Sorted/extend_1000/Hard_Mask/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_1.1/UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME_BIO/" .

}


function run_get_bg_random(){
    s=$1
    ref="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/reference/"${s}".fa"
    for i in 150 300
    do
	folder="crm_"${i}
	cd ${folder}
	cp ${run_get_random_seq_script} .
	cp ${change_peak_name_background_script} .
	pbs="run_clean_fa_bg_change_name.pbs"
	echo -e ${pbs_header} > ${pbs}
	crm="ALL_CRMs_"${i}
	echo -e "bash run_get_random_seq.sh ${crm} ${ref}" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}


function run_extract_cre_score(){
    s=$1
    for i in 150 300
    do
	folder="crm_"${i}
	cd ${folder}
	cp ${extract_cre_sequences_script} .
	meme_bio_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO"
	pbs="run_extract_cre_score.pbs"
	echo -e ${pbs_header} > ${pbs}
	all_crm="ALL_CRMs_"${i}
	seq_name=${all_crm}".crm.bed.clean.fa"
	echo -e "python extract_cre_sequences.py ${seq_name} ${all_crm} ${meme_bio_path} cre" >> ${pbs}
	qsub ${pbs}

	pbs="run_extract_cre_score_randome.pbs"
	random_seq_name=${all_crm}".crm.bed.clean.fa.bg.fasta_peak_name"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python extract_cre_sequences.py ${random_seq_name} ${all_crm} ${meme_bio_path} cre_random" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}

function run_compute_tfbs_score(){
    s=$1
    umotif_folder="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO/"
    cd ${umotif_folder}
    cp ${compute_umotif_binding_score_script} .
    pbs="run_compute_tfbs_score.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python compute_umotif_binding_score.py" >> ${pbs}
    #qsub ${pbs}
    ls umotif_score_stats.txt
    cd ${cwd_path}

}

function run_compute_score_pair(){
    s=$1

    network_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Umotif_Interaction_Score.txt"
    network_random_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Umotif_Interaction_Score.txt.random"
    
    umotif_score="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO/umotif_score_stats.txt"
    
    ls ${umotif_score}
    for i in 150 300
    do
	folder="crm_"${i}
	cd ${folder}

	cp ${umotif_score} .
	cp ${compute_crm_score_v7_0_pair_script} .
	pbs="run_compute_score.pbs"
	echo -e ${pbs_header} > ${pbs}
	score="ALL_CRMs_"${i}".cre.bed.fa.score"
	crm="ALL_CRMs_"${i}
	echo -e "python compute_crm_score_v7_0_pair.py ${score} ${crm} MEAN ${network_path} cre" >> ${pbs}
	qsub ${pbs}



	pbs="run_compute_score.random.pbs"
	echo -e ${pbs_header} > ${pbs}
	random_score="ALL_CRMs_"${i}".cre_random.bed.fa.score"
	crm="ALL_CRMs_"${i}
	echo -e "python compute_crm_score_v7_0_pair.py ${random_score} ${crm} MEAN ${network_random_path} random" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
    

}


function run_move_umotif_tfbs_score_human_mouse(){
    s=$1
    umotif_score="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO/umotif_score_stats.txt"
    network_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Umotif_Interaction_Score.txt"
    network_random_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/Umotif_Interaction_Score.txt.random"
    for i in 150 300
    do
	cd "crm_"${i}
	cp ${umotif_score} SMALL_PATCH_CRMS/
	cp ${umotif_score} SMALL_PATCH_CRMS_Random/
	cp ${network_path} SMALL_PATCH_CRMS/
	cp ${network_random_path} SMALL_PATCH_CRMS_Random/

	cd ../
    done

}


function run_compute_p(){

    for cutoff in 150 300
    do
	folder="crm_"${cutoff}
	cd ${folder}
	cp ${compute_p_value_crm_v2_script} .
	pbs="run_compute_p_value_"${cutoff}".pbs"
	#crm_score="ALL_CRMs_"${cutoff}".pos_site.keep_pos_site.0.n-1.cre.score"
	#random_score="ALL_CRMs_"${cutoff}".pos_site.keep_pos_site.0.n-1.random.score"


	crm_score="ALL_CRMs_"${cutoff}".pos_site.keep_pos_site.n-1.crm.score"
	random_score="ALL_CRMs_"${cutoff}".pos_site.keep_pos_site.n-1.random.score"

	echo -e ${pbs_header} > ${pbs}
	echo -e "sort -k5nr ${crm_score} > ${crm_score}.sort" >> ${pbs}
	echo -e "sort -k5nr ${random_score} > ${random_score}.sort" >> ${pbs}
	echo -e "python compute_p_value_crm_v2.py ${crm_score}.sort ${random_score}.sort" >> ${pbs}
	qsub ${pbs}

	cd ../
    done


}



function run_split_batch_to_compute_score(){
    for cutoff in 150 300
    do
	cd "crm_"${cutoff}
	
	cp ${run_random_and_crm_score_script} .
	pbs="run_split_crm_and_random_"${cutoff}".pbs" 
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_random_and_crm_score.sh ${cutoff}" >> ${pbs}
	#qsub ${pbs}
	ls SMALL*/
	cd ../
    done
}

function run_extract_cre_score_small_batch_code(){
    s=$1
    cp ${run_extract_cre_score_small_batch_script} .
    bash run_extract_cre_score_small_batch.sh ${s}
}

function rum_cat_score_patch(){
    for i in 150 300
    do
	folder="crm_"${i}
	cd ${folder}
	cd SMALL_PATCH_CRMS/
	cat small_patch_all_crms_*_index.bed.pos_site.keep_pos_site.0.n-1.crm.score > "ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.crm.score"
	cp "ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.crm.score" ../

	cd ../

	cd SMALL_PATCH_CRMS_Random/
	cat small_patch_all_crms_*_index.bed.pos_site.keep_pos_site.0.n-1.random.score > "ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.random.score"
	cp "ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.random.score" ../
	cd ../
	cd ../
    done


}

function run_compute_random_p_value_int(){
    for i in 150 300
    do
	folder="crm_"${i}
	cd ${folder}
	cp ${compute_p_value_v2_script} .
	#cut -f5 "ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.random.score.sort" > "ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.random.score.sort.score"
	score_sort="ALL_CRMs_"${i}".pos_site.keep_pos_site.n-1.random.score.sort.score"
	pbs="run_compute_p_value_"${i}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_p_value_v2.sh ${score_sort}" >> ${pbs}
	qsub ${pbs}
	
	cd ../
    done

}



for s in human mouse #human #mouse  # ce dap 
do
    folder="UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak"
    cd ${folder}
    #mkdir -p Merge_CRM_Norm/CRM                                                                                     
    #run_randomize_network
    #du -h Merge_CRM_Norm/TOTAL_KEEP_BINDING_SITES_Norm.bed
    #run_convert_tfbs_split_overlap
    #run_get_keep_tfbs_for_cluster
    #run_merge

    cd Merge_CRM_Norm
    #run_split_chr
    #sort_uniq
    #run_merge_crm
    cd CRM
    #run_cat_merge_crm
    #move_meme_bio ${s}
    #run_get_bg_random ${s}
    #run_extract_cre_score ${s}
    #run_compute_tfbs_score ${s}
    #run_compute_score_pair ${s}
    #ls *.score
    #run_compute_p 
    run_compute_random_p_value_int
    #run_split_batch_to_compute_score
    #run_extract_cre_score_small_batch_code ${s}
    #run_move_umotif_tfbs_score_human_mouse ${s}
    #rum_cat_score_patch
    cd ../
    cd ../
    cd ${cwd_path}
done
