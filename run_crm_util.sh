function make_cluster_folder(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    for origin in ${origin_files}
    do
        folder=${origin/".30.8.8_0.sites.bed.origin.origin_peak"/}
        mkdir -p ${folder}
    done
}


function sort_origin_peak(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    for origin in ${origin_files}
    do
	pbs="run_sort_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "LC_ALL=C sort -k1,1 -k2,2n ${origin} > ${origin}.sort" >> ${pbs}
	qsub ${pbs}
    done
}

function run_overlap(){
    cp ${run_intersect_origin_peak_single_script} .
    for i in {1..600}
    do
	origin_file="cluster_"${i}.30.8.8_0.sites.bed.origin.origin_peak.sort
	if [[ -f ${origin_file} ]];then
	    pbs="run_overlap_origin_peak_cluster_"${i}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bash run_intersect_origin_peak_single.sh ${origin_file}" >> ${pbs}	    
	    qsub ${pbs}
	fi
    done
}

function run_count_dataset_peak_number(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    cp ${dump_origin_site_script} .
    for origin in ${origin_files}
    do
	pbs="run_count_dataset_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python dump_origin_site.py ${origin}" >> ${pbs}
	qsub ${pbs}
    done

}


function run_compute_dist(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak

    for origin in ${origin_files}
    do
	folder=${origin/".30.8.8_0.sites.bed.origin.origin_peak"/}
	cp ${run_compute_closest_tfbs_distance_script} ${folder}
	cp ${compute_closest_tfbs_distance_script} ${folder}
	cd ${folder}
	pbs="run_get_closest_dist.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_compute_closest_tfbs_distance.sh" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}

function run_create_pair(){
    cp ${create_cluster_pair_script} .
    python create_cluster_pair.py
}


function run_compute_score(){
    pairs=cluster_*.pair
    cp ${compute_interaction_score_script} .

    for pair in ${pairs}
    do
	pbs="run_compute_score_"${pair}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_interaction_score.py ${pair}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_cat_score(){
    cat cluster_*.score > Umotif_Interaction_Score.txt
}



function run_convert_tfbs_split_overlap(){
    #convert_tfbs_format_script=${cwd_path}"/convert_tfbs_format.py"
    #run_split_tfbs_script=${cwd_path}"/run_split_tfbs.sh"

    folders=cluster_*/
    for folder in ${folders}
    do
	cd ${folder}
	#rm *.tfbs
	#rm *.tfbs.dataset_info
	#cp ${convert_tfbs_format_script} .
	cp ${convert_tfbs_format_v3_script} .
	cp ${run_split_tfbs_script} .
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
    cutoff=0.1
    cp ${get_keep_tfbs_for_cluster_script} .
    cp ${run_split_tfbs_script} .
    for origin in ${origin_peak}
    do
	cluster_index=${origin/".30.8.8_0.sites.bed.origin.origin_peak"/}
	keep_tfbs_name=${cluster_index}".KEEP_TFBS"
	
	pbs="run_get_keep_tfbs_"${cluster_index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python get_keep_tfbs_for_cluster.py ${cluster_index} ${cutoff}" >> ${pbs}
	echo -e "bash run_split_tfbs.sh ${keep_tfbs_name} ${cutoff}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_merge(){
    mkdir -p Merge_CRM_Norm/
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

function run_merge_crm(){
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

function run_compute_binding_score(){
    cd UMOTIF_MEME_BIO
    cp ${compute_umotif_binding_score_script} .
    pbs="run_compute_umotif_binding_score.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python compute_umotif_binding_score.py" >> ${pbs}
    qsub ${pbs}
    cd ../
}

function run_randomize_network(){
    cp ${network_randomnize_script} .
    pbs="run_randomnize_network.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python network_randomnize.py Umotif_Interaction_Score.txt" >> ${pbs}
    qsub ${pbs}
}

function run_compute_score(){
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
	meme_bio_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO"
	pbs="run_extract_cre_score.pbs"
	echo -e ${pbs_header} > ${pbs}
	all_crm="ALL_CRMs_"${i}
	seq_name=${all_crm}".crm.bed.clean.fa"
	#echo -e "python extract_cre_sequences.py ${seq_name} ${all_crm} ${meme_bio_path} cre" >> ${pbs}

	random_seq_name=${all_crm}".crm.bed.clean.fa.bg.fasta_peak_name"
	echo -e "python extract_cre_sequences.py ${random_seq_name} ${all_crm} ${meme_bio_path} cre_random" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}


function run_compute_score_pair(){
    s=$1

    network_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000/UMOTIF_BED_MERGE_Origin_Peak/Umotif_Interaction_Score.txt"
    network_random_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000/UMOTIF_BED_MERGE_Origin_Peak/Umotif_Interaction_Score.txt.random"
    
    umotif_score="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000/UMOTIF_BED_MERGE_Origin_Peak/Merge_CRM_Norm/CRM/UMOTIF_MEME_BIO/umotif_score_stats.txt"
    
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
	#qsub ${pbs}



	pbs="run_compute_score.random.pbs"
	echo -e ${pbs_header} > ${pbs}
	random_score="ALL_CRMs_"${i}".cre_random.bed.fa.score"
	crm="ALL_CRMs_"${i}
	echo -e "python compute_crm_score_v7_0_pair.py ${random_score} ${crm} MEAN ${network_random_path} random" >> ${pbs}
	qsub ${pbs}


	cd ../
    done
    

}




