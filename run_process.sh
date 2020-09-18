#!/bin/bash
cwd_path="/nobackup/zcsu_research/npy/UMOTIF_BINDING_SITES_PEAK_FOLDER_HUMAN_1000/UMOTIF_BED_MERGE_Origin_Peak"
run_compute_closest_tfbs_distance_script=${cwd_path}"/run_compute_closest_tfbs_distance.sh"
compute_closest_tfbs_distance_script=${cwd_path}"/compute_closest_tfbs_distance.py"
strip_files_script=${cwd_path}"/strip_files.sh"
convert_tfbs_format_script=${cwd_path}"/convert_tfbs_format.py"
convert_tfbs_format_v2_script=${cwd_path}"/convert_tfbs_format_v2.py"
run_split_tfbs_script=${cwd_path}"/run_split_tfbs.sh"
run_convert_tfbs_format_split_script=${cwd_path}"/run_convert_tfbs_format_split.sh"
compute_closest_tfbs_distance_v2_script=${cwd_path}"/compute_closest_tfbs_distance_v2.py"

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
	echo -e "LC_ALL=C sort --parallel=8 -k1,1 -k2,2n ${origin} > ${origin}.sort" >> ${pbs}
	qsub ${pbs}
    done


}


function run_overlap(){
    for i in {1..250}
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

function run_strip_files(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak.sort
    for origin in ${origin_files}
    do
	folder=${origin/".30.8.8_0.sites.bed.origin.origin_peak.sort"/}
	cp ${strip_files_script} ${folder}
	cd ${folder}
	bash strip_files.sh
	cd ../
    done


}


function run_count_dataset_peak_number(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    for origin in ${origin_files}
    do
	pbs="run_count_dataset_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python dump_origin_site.py ${origin}" >> ${pbs}
	qsub ${pbs}
    done

}


function run_left_unrun_dist(){
    for i in {13..17} 20 23 28 29 30 35 #{1..11} 
    do
	folder="cluster_"${i}
	cd ${folder}
	#f=(`ls -1t *.dist|head -1`)
	#rm ${f}
	overlap_files=cluster_${i}-cluster_*.overlap
	for overlap in ${overlap_files}
	do
	    if [[ -s ${overlap} ]];then
		pbs="run_compute_dist_"${overlap}".pbs"
		echo -e ${pbs_header} > ${pbs}
		echo -e "python compute_closest_tfbs_distance.py ${overlap}" >> ${pbs}
		qsub ${pbs}

	    else
		#touch ${overlap}.dist
		:
	    fi
	done
	cd ../
    done

}

function check_unrun_dist(){
    folders=cluster_*/
    for folder in ${folders}
    do
	cd ${folder}
	overlap_files=cluster_*-cluster_*.overlap
	for overlap in ${overlap_files}
	do
	    if [[ ! -f ${overlap}.dist ]];then
		pbs="run_compute_dist_"${overlap}".pbs"
		echo -e ${pbs_header} > ${pbs}
		echo -e "python compute_closest_tfbs_distance.py ${overlap}" >> ${pbs}
		echo ${pbs}
	    fi
	done

	cd ../
    done

}

function run_compute_score(){
    pairs=cluster_*.pair

    for pair in ${pairs}
    do
	pbs="run_compute_score_"${pair}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_interaction_score.py ${pair}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_convert_tfbs_split_overlap(){
    #convert_tfbs_format_script=${cwd_path}"/convert_tfbs_format.py"
    #run_split_tfbs_script=${cwd_path}"/run_split_tfbs.sh"

    folders=cluster_*/
    for folder in ${folders}
    do
	cd ${folder}
	#cp ${convert_tfbs_format_script} .
	cp ${convert_tfbs_format_v2_script} .
	cp ${run_split_tfbs_script} .
	cp ${run_convert_tfbs_format_split_script} .
	pbs="run_convert_tfbs_format_split.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_convert_tfbs_format_split.sh" >> ${pbs}
	qsub ${pbs}
	cd ../
    done

}


function run_remove_unfinished_overlap(){
    while IFS= read -r line
    do
	path_0=${line/"run_compute_dist_"/}
	path_1=${path_0/".overlap.pbs"/}
	path=(`echo ${path_1}|tr "-" " "`)
	cd ${path}
	#qsub ${line}
	rm ${path_1}.overlap.dist
	cd ../
    done<"left_overlap_compute_dist"
}


function rerun_unfinished_overlap_v2(){
    while IFS= read -r line
    do
	path_0=${line/"run_compute_dist_"/}
	path_1=${path_0/".overlap.pbs"/}
	path=(`echo ${path_1}|tr "-" " "`)
	cd ${path}
	cp ${compute_closest_tfbs_distance_v2_script} .
	overlap=${path_1}".overlap"
	#pbs="run_rerun_overlap_"${overlap}".pbs"
	#echo -e ${pbs_header} > ${pbs}
	#echo -e "python compute_closest_tfbs_distance_v2.py ${overlap}" >> ${pbs}
	#qsub ${pbs}
	mv ${overlap}".dist_v2" ${overlap}".dist"
	cd ../
    done<"left_overlap_compute_dist_v2"
}


function run_unfinished_left_overlap_dist(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    for origin in ${origin_files}
    do
	folder=${origin/".30.8.8_0.sites.bed.origin.origin_peak"/}
	#cp ${run_compute_closest_tfbs_distance_script} ${folder}
	#cp ${compute_closest_tfbs_distance_script} ${folder}
	cd ${folder}
	overlap_files=cluster_*-cluster_*.overlap
	for overlap in ${overlap_files}
	do
	    if [[ ! -f ${overlap}.dist ]];then
		pbs="run_compute_dist_"${overlap}".pbs"
		echo -e ${pbs_header} > ${pbs}
		echo -e "python compute_closest_tfbs_distance.py ${overlap}" >> ${pbs}
		echo ${pbs}
	    fi
	done


	cd ../
    done

}


function run_get_keep_tfbs_for_cluster(){
    origin_peak=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    cutoff=0.2
    for origin in ${origin_peak}
    do
	cluster_index=${origin/".30.8.8_0.sites.bed.origin.origin_peak"/}
	keep_tfbs_name=${cluster_index}".KEEP_TFBS"
	
	echo ${cluster_index}
	pbs="run_get_keep_tfbs_"${cluster_index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python get_keep_tfbs_for_cluster.py ${cluster_index} ${cutoff}" >> ${pbs}
	echo -e "bash run_split_tfbs.sh ${keep_tfbs_name} ${cutoff}" >> ${pbs}
	qsub ${pbs}
    done

}


function run_merge_split(){
    pbs="run_merge_tfbs.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python merge_keep_tfbs.py" >> ${pbs}
    qsub ${pbs}

}

function run_umotif_origin_peak_number(){
    origin_peak=cluster_*.30.8.8_0.sites.bed.origin.origin_peak
    for origin in ${origin_peak}
    do
	pbs="run_count_peak_number_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python count_origin_peak_cluster_origin_peak.py ${origin}" >> ${pbs}
	qsub ${pbs}
    done

}

#make_cluster_folder
#sort_origin_peak
#run_overlap
#run_compute_dist
#run_strip_files
#run_count_dataset_peak_number
#run_left_unrun_dist
#check_unrun_dist
#run_compute_score
#run_convert_tfbs_split_overlap
#run_remove_unfinished_overlap
#run_unfinished_left_overlap_dist
#rerun_unfinished_overlap_v2
#run_get_keep_tfbs_for_cluster
#run_merge_split
#run_umotif_origin_peak_number
