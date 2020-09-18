#!/bin/bash

cwd_path="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER"
filter_binding_script=${cwd_path}"/filter_binding_sites.py"
sort_and_merge_script=${cwd_path}"/sort_and_merge_sites_bed_cluster.sh"
sort_and_merge_mt_script=${cwd_path}"/sort_and_merge_sites_bed_cluster_mt.sh"
sort_and_merge_sites_bed_cluster_2_path=${cwd_path}"/sort_and_merge_sites_bed_cluster_2.sh"
paser_prosampler_single_script=${cwd_path}"/paser_prosampler_single.py"
build_umotif_database_folder=${cwd_path}"/build_umotif_database_folder.sh"
run_tomtom_for_umotifs_script=${cwd_path}"/run_tomtom_for_umotifs.sh"
match_known_motif_stats_script=${cwd_path}"/match_known_motif_stats.py"
paser_site_to_bed_script=${cwd_path}"/paser_site_to_bed.py"
sort_merge_bed_site_script=${cwd_path}"/sort_and_merge_sites_bed_cluster.sh"
filter_repeat_script=${cwd_path}"/filter_binding_sites.py"
convert_site_bed_to_origin_script=${cwd_path}"/map_binding_sites_to_original_peak.py"
dump_origin_site_script=${cwd_path}"/dump_origin_site.py"
append_dataset_origin_peak_to_chromesome_script=${cwd_path}"/append_dataset_origin_peak_to_chromesome.py"
padding_merged_umotif_script=${cwd_path}"/padding_merged_umotif.py"
reference_size="/nobackup/zcsu_research/npy/cistrom/reference/hg38.chrom.sizes"
hg38_reference="/nobackup/zcsu_research/npy/cistrom/reference/hg38.fa"
cat_site_script=${cwd_path}"/cat_site_bed_cluster.py"
run_cat_site_bed_cluster_batch_script=${cwd_path}"/run_cat_site_bed_cluster_batch.sh"
sort_and_merge_sites_bed_cluster_small_file_script=${cwd_path}"/sort_and_merge_sites_bed_cluster_small_file.sh"
paddding_fa_bg_prosampler_small_file_script=${cwd_path}"/paddding_fa_bg_prosampler_small_file.sh"
build_umotif_database_folder_padding_30_script=${cwd_path}"/build_umotif_database_folder_padding_30.sh"
run_tomtom_for_umotifs_script=${cwd_path}"/run_tomtom_for_umotifs.sh"
reformat_spic_script=${cwd_path}"/reformat_spic.py"
run_compute_spic_script=${cwd_path}"/run_compute_spic.sh"
remove_cluster_bed_unsort_script=${cwd_path}"/remove_cluster_bed_unsort.sh"
get_unique_motifs_script=${cwd_path}"/get_unique_motifs.sh"
run_plot_logo_script=${cwd_path}"/run_plot_logo.sh"
filter_repeat_cluster_bed_script=${cwd_path}"/filter_binding_sites_cluster_bed.py"
map_binding_sites_to_padding_peak_to_original_peak_script=${cwd_path}"/map_binding_sites_to_padding_peak_to_original_peak.py"
convert_origin_to_tfbs_script=${cwd_path}"/convert_origin_to_tfbs.py"


function run_filter_repeat_site(){
    cp ${filter_repeat_script} .
    #mkdir UMOTIF_BED_MERGE_CLEAN

    merge_site_files=cluster_*.8_0.sites.bed.sort.merge
    for merge_site in ${merge_site_files}
    do
	pbs="run_remove_repeat_peak_umotif_"${merge_site}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python filter_binding_sites.py ${merge_site}" >> ${pbs}
	qsub ${pbs}
    done

}

function check_un_run_filter_repeat_site(){
    merge_site_files=cluster_*.8_0.sites.bed.sort.merge
    for merge_site in ${merge_site_files}
    do
	output="UMOTIF_BED_MERGE_CLEAN/"${merge_site}".clean"

	if [[ ! -f ${output} ]];then
	    pbs="run_remove_repeat_peak_umotif_"${merge_site}".pbs"
	    qsub ${pbs}
	fi
    done
}



function run_dump(){
    origin_files=*sites.bed.sort.merge.clean.origin
    cp ${dump_origin_site_script} .
    
    for origin in ${origin_files}
    do
	
	if [[ ! -f ${origin}".dataset_number.simplejson" ]];then
	    pbs="run_dump_origin_site_"${origin}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python dump_origin_site.py ${origin}" >> ${pbs}
	    qsub ${pbs}
	fi
	
    done
}





function run_append_dataset(){
    origin_files=*sites.bed.sort.merge.clean.origin

    cp ${append_dataset_origin_peak_to_chromesome_script} .

    for origin in ${origin_files}
    do
	pbs="run_append_dataset_index_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python append_dataset_origin_peak_to_chromesome.py ${origin}" >> ${pbs}
	qsub ${pbs}
    done
}

function check_run_append_dataset(){
    origin_files=*sites.bed.sort.merge.clean.origin

    #cp ${append_dataset_origin_peak_to_chromesome_script} .

    for origin in ${origin_files}
    do
	pbs="run_append_dataset_index_"${origin}".pbs"
	#echo -e ${pbs_header} > ${pbs}
	#echo -e "python append_dataset_origin_peak_to_chromesome.py ${origin}" >> ${pbs}
	#qsub ${pbs}

	output="/nobackup/zcsu_research/npy/UMOTIF_BINDING_SITES_PEAK_FOLDER_HUMAN_1000/UMOTIF_BED_MERGE_Origin_Peak/"${origin}".origin_peak"

	if [[ ! -f ${output} ]];then
	    qsub ${pbs}

	fi
    done
}


function run_build_umotif_database(){
    cp ${build_umotif_database_folder} .
    pbs="run_build_umotif_database.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_umotif_database_folder.sh" >> ${pbs}
    qsub ${pbs}

}

function run_padding_bg_prosampler(){
    for i in {1..1600}
    do
	cluster_name="cluster_"${i}

	if [[ -d ${cluster_name} ]];then

	    cd ${cluster_name}
	    cp ${padding_merged_umotif_script} .

	    cluster_clean_bed=${cluster_name}".bed.sort.merge.clean"
	    if [[ ${i} -lt 30 ]];then
		#pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=100GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
		pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=8GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    else
		pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=8GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    fi

	    #pbs="run_padding_fa_bg_markov_"${cluster_name}".pbs"
	    #echo -e ${pbs_header} > ${pbs}
	    #echo -e "python padding_merged_umotif.py ${cluster_clean_bed} 20 ${reference_size}" >> ${pbs}
	    #echo -e "python padding_merged_umotif.py ${cluster_clean_bed} 30 ${reference_size}" >> ${pbs}
	    #echo -e "bedtools getfasta -fi ${hg38_reference} -bed ${cluster_clean_bed}.padding_20 -fo ${cluster_clean_bed}.padding_20.fa" >> ${pbs}
	    #echo -e "bedtools getfasta -fi ${hg38_reference} -bed ${cluster_clean_bed}.padding_30 -fo ${cluster_clean_bed}.padding_30.fa" >> ${pbs}
	    #echo -e "markov -i ${cluster_clean_bed}.padding_20.fa -b ${cluster_clean_bed}.padding_20.fa.bg -f 1" >> ${pbs}
	    #echo -e "markov -i ${cluster_clean_bed}.padding_30.fa -b ${cluster_clean_bed}.padding_30.fa.bg -f 1" >> ${pbs}
	    #qsub ${pbs}
	    output=${cluster_clean_bed}".padding_30.info"
	    pbs="run_padding_fa_bg_markov_"${cluster_name}".padding.pbs"

	    if [[ ! -f ${output} ]];then

		echo -e ${pbs_header} > ${pbs}
		echo -e "python padding_merged_umotif.py ${cluster_clean_bed} 30 ${reference_size}" >> ${pbs}
		qsub ${pbs}
	    fi

	    cd ../
	fi
	
    done



}


function check_run_padding_bg_prosampler(){
    for i in {1..1600}
    do
	cluster_name="cluster_"${i}
	cluster_clean_bed=${cluster_name}".bed.sort.merge.clean"
	if [[ -d ${cluster_name} ]];then

	    cd ${cluster_name}
	    pbs="run_padding_fa_bg_markov_"${cluster_name}".pbs"
	    if [[ ! -f ${cluster_clean_bed}.padding_30.fa.bg ]];then
		qsub ${pbs}
		
	    fi
	    cd ../
	fi
    done
}


function run_prosampler_paser_prosampler(){

    for i in {1..1600}
    do
	cluster_name="cluster_"${i}	
	cluster_clean_bed=${cluster_name}".bed.sort.merge.clean"
	cluster_clean_bed_padding_20=${cluster_clean_bed}".padding_20.fa"
	cluster_clean_bed_padding_20_bg=${cluster_clean_bed}".padding_20.fa.bg"
	cluster_clean_bed_padding_30=${cluster_clean_bed}".padding_30.fa"
	cluster_clean_bed_padding_30_bg=${cluster_clean_bed}".padding_30.fa.bg"

	if [[ -d ${cluster_name} ]];then
	    cd ${cluster_name}
	    cp ${paser_prosampler_single_script} .

	    if [[ ${i} -lt 10 ]];then
		pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=128GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    else
		pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=40GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    fi
	    
	    
	    pbs="run_prosampler_paser_prosampler_"${cluster_name}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "ProSampler -i ${cluster_clean_bed_padding_20} -b ${cluster_clean_bed_padding_20_bg} -o ${cluster_name}.20.8.6 -k 8 -l 6 -t 8" >> ${pbs}
	    echo -e "ProSampler -i ${cluster_clean_bed_padding_20} -b ${cluster_clean_bed_padding_20_bg} -o ${cluster_name}.20.8.4 -k 8 -l 4 -t 8" >> ${pbs}
	    echo -e "ProSampler -i ${cluster_clean_bed_padding_30} -b ${cluster_clean_bed_padding_30_bg} -o ${cluster_name}.30.8.8 -k 8 -l 8 -t 8" >> ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_name}.20.8.6.meme" >> ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_name}.20.8.4.meme" >> ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_name}.30.8.8.meme" >> ${pbs}
	    qsub ${pbs}
	    cd ../
	fi
    done
}





function check_run_prosampler_paser_prosampler(){

    for i in {1..1600}
    do
	cluster_name="cluster_"${i}	
	cluster_clean_bed=${cluster_name}".bed.sort.merge.clean"
	cluster_clean_bed_padding_20=${cluster_clean_bed}".padding_20.fa"
	cluster_clean_bed_padding_20_bg=${cluster_clean_bed}".padding_20.fa.bg"
	cluster_clean_bed_padding_30=${cluster_clean_bed}".padding_30.fa"
	cluster_clean_bed_padding_30_bg=${cluster_clean_bed}".padding_30.fa.bg"

	if [[ -d ${cluster_name} ]];then
	    cd ${cluster_name}
	    cp ${paser_prosampler_single_script} .

	    if [[ ${i} -lt 10 ]];then
		#pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=128GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
		:
	    else
		#pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=40GB\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
		:
	    fi
	    
	    pbs="run_prosampler_paser_prosampler_"${cluster_name}".pbs"
	    output=${cluster_name}".30.8.8.meme"
	    
	    #rename "30.8.4" "30.8.8" *30.8.4*
	    #python paser_prosampler_single.py ${cluster_name}.30.8.8.meme

	    #if [[ ! -f ${output} ]];then
	    #echo ${pbs}
	    #fi
	    
	    

	    if [[ -f ${output} ]];then
		pbs="run_paser_30_8_8.pbs"
		output_folder=${cluster_name}".30.8.8_motif"
		if [ ! "$(ls -A ${output_folder})" ];then
		    qsub ${pbs}
		fi
		#echo -e ${pbs_header} > ${pbs}
		#echo -e "python paser_prosampler_single.py ${cluster_name}.30.8.8.meme" >> ${pbs}
		#qsub ${pbs}
	    fi
	    
	    cd ../
	fi
    done
}



function run_tomtom_for_umotif(){

    #cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME
    cd UMOTIF_FOR_ALL_CLUSTER_8_20/UMOTIF_MEME
    cp ${run_tomtom_for_umotifs_script} .

    pbs="run_tomtom_umotif_0.5.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_tomtom_for_umotifs.sh 0.5" >> ${pbs}
    qsub ${pbs}

    cd ../../
}

function run_cat_sites_small_batch(){
    cp ${cat_site_script} .
    cp ${run_cat_site_bed_cluster_batch_script} .
    pbs="run_cat_sites_batch.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_cat_site_bed_cluster_batch.sh" >> ${pbs}
    qsub ${pbs}
}


function run_cat_sites_big(){
    for i in {1..9}
    do
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    pbs="run_cat_sites_"${i}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python cat_site_bed_cluster.py ${cluster_folder}" >> ${pbs}
	    qsub ${pbs}
	fi
    done
}



function run_sort_and_merge_sites_bed_cluster_mt_big(){

    for i in {1..10}
    do
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    cp ${filter_binding_script} .
	    cp ${sort_and_merge_mt_script} .
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=16,mem=128GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    pbs="run_sort_and_merge_sites_bed_cluster_mt_big.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    cluster_bed=${cluster_folder}".bed"
	    echo -e "bash sort_and_merge_sites_bed_cluster_mt.sh ${cluster_bed} 16" >> ${pbs}
	    echo -e "cut -f1,2,3 ${cluster_bed}.sort.merge > ${cluster_bed}.sort.merge.bed" >> ${pbs}
	    qsub ${pbs}

	    cd ../
	fi
    done


    for i in {11..150}
    do
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    cp ${filter_binding_script} .
	    cp ${sort_and_merge_mt_script} .
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=8,mem=64GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    pbs="run_sort_and_merge_sites_bed_cluster_mt_big.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    cluster_bed=${cluster_folder}".bed"
	    echo -e "bash sort_and_merge_sites_bed_cluster_mt.sh ${cluster_bed} 8" >> ${pbs}
	    echo -e "cut -f1,2,3 ${cluster_bed}.sort.merge > ${cluster_bed}.sort.merge.bed" >> ${pbs}
	    qsub ${pbs}
	    cd ../
	fi
    done


    cp ${sort_and_merge_sites_bed_cluster_small_file_script} .
    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=8,mem=64GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
    pbs="run_small_sort_and_merge_sites_bed_cluster.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash sort_and_merge_sites_bed_cluster_small_file.sh" >> ${pbs}
    qsub ${pbs}
}




function run_check_unfinished_sort_and_merge_sites_bed_cluster_mt_big(){
    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=16,mem=128GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
    for i in {1..150}
    do
	cluster_folder="cluster_"${i}

	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    output_err=run_sort_and_merge_sites_bed_cluster_mt_big.pbs.e*
	    info=(`head -n 1 ${output_err}`)
	    flag=${info[0]}

	    if [[ ${flag} == "sort:" ]];then
		#cp run_sort_and_merge_sites_bed_cluster_mt_big.pbs run_sort_and_merge_sites_bed_cluster_mt_big_rerun.pbs
		#qsub run_sort_and_merge_sites_bed_cluster_mt_big_rerun.pbs
		echo ${output}
	    elif [[ ${flag} == "Error:" ]];then
		#cp run_sort_and_merge_sites_bed_cluster_mt_big.pbs run_sort_and_merge_sites_bed_cluster_mt_big_rerun.pbs
		#qsub run_sort_and_merge_sites_bed_cluster_mt_big_rerun.pbs
		echo ${output}
	    elif [[ ${flag} == "" ]];then
		#cp run_sort_and_merge_sites_bed_cluster_mt_big.pbs run_sort_and_merge_sites_bed_cluster_mt_big_rerun.pbs
		#qsub run_sort_and_merge_sites_bed_cluster_mt_big_rerun.pbs
		echo ${output}
	    else
		:
	    fi

	    cd ../
	fi
    done

}


function run_padding_fa_markov_prosampler_prosampler(){

    for i in {1..10}
    do
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    cp ${padding_merged_umotif_script} .
	    cp ${paser_prosampler_single_script} .
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=388GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    cluster_name=${cluster_folder}
	    cluster_bed=${cluster_folder}".bed"
	    cluster_clean_bed=${cluster_bed}.sort.merge.bed
	    pbs="run_padding_fa_markov.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python padding_merged_umotif.py ${cluster_clean_bed} 30 ${reference_size}" >> ${pbs}
	    echo -e "bedtools getfasta -fi ${hg38_reference} -bed ${cluster_clean_bed}.padding_30 -fo ${cluster_clean_bed}.padding_30.fa" >> ${pbs}
	    echo -e "markov -i ${cluster_clean_bed}.padding_30.fa -b ${cluster_clean_bed}.padding_30.fa.bg -f 1" >> ${pbs}
	    echo -e "ProSampler -i ${cluster_clean_bed}.padding_30.fa -b ${cluster_clean_bed}.padding_30.fa.bg -o ${cluster_folder}.30.8.8 -k 8 -l 8 -t 8" >> ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_folder}.30.8.8.meme" >> ${pbs}
	    qsub ${pbs}

	    cd ../
	fi
    done


    for i in {11..300}
    #for i in {151..300}
    do
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    cp ${padding_merged_umotif_script} .
	    cp ${paser_prosampler_single_script} .
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=128GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	    cluster_name=${cluster_folder}
	    cluster_bed=${cluster_folder}".bed"
	    cluster_clean_bed=${cluster_bed}.sort.merge.bed
	    pbs="run_padding_fa_markov.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python padding_merged_umotif.py ${cluster_clean_bed} 30 ${reference_size}" >> ${pbs}
	    echo -e "bedtools getfasta -fi ${hg38_reference} -bed ${cluster_clean_bed}.padding_30 -fo ${cluster_clean_bed}.padding_30.fa" >> ${pbs}
	    echo -e "markov -i ${cluster_clean_bed}.padding_30.fa -b ${cluster_clean_bed}.padding_30.fa.bg -f 1" >> ${pbs}
	    echo -e "ProSampler -i ${cluster_clean_bed}.padding_30.fa -b ${cluster_clean_bed}.padding_30.fa.bg -o ${cluster_folder}.30.8.8 -k 8 -l 8 -t 8" >> ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_folder}.30.8.8.meme" >> ${pbs}
	    qsub ${pbs}
	    cd ../
	fi
    done


    cp ${paddding_fa_bg_prosampler_small_file_script} .
    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=50GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
    pbs="run_small_sort_and_merge_sites_bed_cluster.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash paddding_fa_bg_prosampler_small_file.sh" >> ${pbs}
    qsub ${pbs}

}


function check_run_padding_bg_prosampler_diff_inflat(){
    for i in {1..1300}
    do
	cluster_name="cluster_"${i}
	cluster_clean_bed=${cluster_name}".bed.sort.merge.bed"
	if [[ -d ${cluster_name} ]];then

	    cd ${cluster_name}

	    output=${cluster_name}".30.8.8.meme"

	    #if [[ ! -f ${cluster_clean_bed}.padding_30.fa.bg ]];then
		#echo ${cluster_clean_bed}.padding_30.fa.bg
		#more run_padding_fa_markov.pbs
		
	    #fi


	    if [[ ! -f ${output} ]];then
		cp ${paser_prosampler_single_script} .
		pbs="run_unrun_single_"${cluster_clean_bed}".pbs"
		echo -e ${pbs_header} > ${pbs}
		echo -e "ProSampler -i ${cluster_clean_bed}.padding_30.fa -b ${cluster_clean_bed}.padding_30.fa.bg -o ${cluster_name}.30.8.8 -k 8 -l 8 -t 8" >> ${pbs}
		echo -e "python paser_prosampler_single.py ${cluster_name}.30.8.8.meme" >> ${pbs}
		#qsub ${pbs}
		pwd
	    fi
	    cd ../
	fi
    done
}




function run_build_umotif_database(){
    cp ${build_umotif_database_folder_padding_30_script} .
    pbs="run_build_umotif_database_folder_padding_30.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_umotif_database_folder_padding_30.sh" >> ${pbs}
    qsub ${pbs}
}


function run_tomtom_for_umotif(){
    cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME
    cp ${run_tomtom_for_umotifs_script} .

    for i in 0.1 0.5
    do
	pbs="run_tomtom_for_umotifs_"${i}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash run_tomtom_for_umotifs.sh ${i}" >> ${pbs}
	qsub ${pbs}
    done
    cd ../../
}


function run_compute_spic_pair(){
    cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SPIC
    cp ${reformat_spic_script} .
    cp ${run_compute_spic_script} .
    pbs="run_spic_score_pair.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python reformat_spic.py" >> ${pbs}
    echo -e "bash run_compute_spic.sh" >> ${pbs}
    qsub ${pbs}
    cd ../../
}

function run_remove_cluster_bed(){
    cp ${remove_cluster_bed_unsort_script} .
    pbs="run_remove.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash remove_cluster_bed_unsort.sh" >> ${pbs}
    qsub ${pbs}
}

function run_get_match_recovery(){
    cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME
    cp ${get_unique_motifs_script} .
    bash get_unique_motifs.sh 0.5
    cd ../../
}

function run_plot_logo(){
    cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME
    cp ${run_plot_logo_script} .
    pbs="run_plot_logo.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_plot_logo.sh" >> ${pbs}
    qsub ${pbs}
    cd ../../
}

function run_paser_site_to_bed(){
    ls *8_0.sites > umotif_sites_files                                                                                                                                                                                                            
    rm small_patch_sites_files_*                                                                                                                                                                                                                  
    split -l 2 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" umotif_sites_files small_patch_sites_files_     

    cp ${paser_site_to_bed_script} .
    small_patch_files=small_patch_sites_files_*index.txt

    for small_patch in ${small_patch_files}
    do
	pbs="run_batch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_site_to_bed.py ${small_patch} 0" >> ${pbs}
	qsub ${pbs}
    done
}


function run_filter_repeat_site_cluster(){

    for i in {1..1300}
    do
	cluster_name="cluster_"${i}
	cluster_clean_bed=${cluster_name}".bed.sort.merge"
	if [[ -d ${cluster_name} ]];then
	    cd ${cluster_name}
	    cp ${filter_repeat_cluster_bed_script} .
	    pbs="run_remove_repeat_"${cluster_name}".pbs"
	    if [[ ! -f ${cluster_clean_bed}.clean ]];then
		echo -e ${pbs_header} > ${pbs}
		echo -e "python filter_binding_sites_cluster_bed.py ${cluster_clean_bed}" >> ${pbs}
		qsub ${pbs}
	    fi
	    cd ../
	fi
    done
}

function run_convert_sites_to_origin_peak(){
    inflat=$1
    merge_site_files=cluster_*.30.8.8_0.sites.bed

    root_path="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_"${inflat}"/"
    cp ${map_binding_sites_to_padding_peak_to_original_peak_script} .
    for merge_site in ${merge_site_files}
    do
	cluster_index=${merge_site/".30.8.8_0.sites.bed"/}
	#cluster_100.30.8.8_0.sites.bed
	padding_to_origin=${root_path}${cluster_index}"/"${cluster_index}".bed.sort.merge.bed.padding_30"
	origin_peak_path=${root_path}${cluster_index}"/"${cluster_index}".bed.sort.merge.clean"
	
	index=${cluster_index/"cluster_"/}

	
	if [[ ${index} -lt 10 ]];then
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=256GB\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	else
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=40GB\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	fi
	
	pbs="run_convert_sites_to_origin_peak_"${merge_site}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python map_binding_sites_to_padding_peak_to_original_peak.py ${padding_to_origin} ${origin_peak_path} ${merge_site}" >> ${pbs}
	qsub ${pbs}

    done
}

function run_convert_to_origin_peak_with_tfbs(){
    origin_files=cluster_*.30.8.8_0.sites.bed.origin

    #cp ${convert_origin_to_tfbs_script} .
    for origin in ${origin_files}
    do
	pbs="run_convert_origin_tf_tfbs_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python convert_origin_to_tfbs.py ${origin}" >> ${pbs}
	qsub ${pbs}
    done
}


for inflat in 1.1 #1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 3 #1.5 1.6 1.7 1.8 1.9 #2#2.1 2.2 2.3 2.4 2.5 3 #4 #3 3.5 4 #3.5 #3 #3.5 4 
do
    cluster_folder="Cluster_Inflation_"${inflat}

    cd ${cluster_folder}
    
    #run_cat_sites_small_batch
    #run_cat_sites_big
    #run_sort_and_merge_sites_bed_cluster_mt_big
    #run_padding_fa_markov_prosampler_prosampler
    #check_run_padding_bg_prosampler_diff_inflat
    #run_check_unfinished_sort_and_merge_sites_bed_cluster_mt_big

    #run_build_umotif_database
    #run_tomtom_for_umotif
    #run_compute_spic_pair
    #run_remove_cluster_bed
    #echo ${inflat}
    #run_get_match_recovery
    #run_plot_logo

    #run_filter_repeat_site_cluster
    ###############################################
    #run_padding_bg_prosampler
    #check_run_padding_bg_prosampler
    #run_prosampler_paser_prosampler
    #check_run_prosampler_paser_prosampler
    ###############################################


    #rm run_sort_merge_cluster_*.pbs
    #run_sort_merge_cluster
    #sleep 2h
    #run_check_un_run_sort_merge_cluster
    #run_create_markov_bg
    #check_create_markov_bg
    #check_un_finished_merge
    #run_prosampler_l0
    #check_un_finished_prosampler_l0
    #paser_prosampler_l0
    #check_un_finished_paser_prosampler_l0
    #run_build_umotif_database
    #count_match_motifs


    #run_tomtom_for_umotif
    cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
    #mkdir -p UMOTIF_BED/
    cd UMOTIF_BED/
    #run_convert_sites_to_origin_peak ${inflat}
    run_convert_to_origin_peak_with_tfbs
    cd ../
    
    #run_paser_site_to_bed
    #cd UMOTIF_BED/UMOTIF_BED_MERGE/UMOTIF_BED_MERGE_CLEAN/
    #run_sort_merge_site_bed
    #check_run_sort_merge_site_bed
    #run_filter_repeat_site
    #check_un_run_filter_repeat_site
    #ls *.origin|wc -l
    #run_dump
    #run_convert_sites_to_origin_peak

    #run_append_dataset
    #check_run_append_dataset
    
    #cd ../../../
    cd ../../
    cd ../
done
