#!/bin/bash
cwd_path="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/"

human_path=${cwd_path}"human_factor/Sorted/extend_1000/Hard_Mask/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/"
mouse_path=${cwd_path}"mouse_factor/Sorted/extend_1000/Hard_Mask/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/"

#dap_path=${cwd_path}"dap_factor/Sorted/extend_1000/Hard_Mask/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/"
#ce_path=${cwd_path}"ce_factor/Sorted/extend_1000/Hard_Mask/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/"

keep_edges_gt_script=${cwd_path}"keep_edges_gt_0.8.sh"
convert_graph_format_script=${cwd_path}"convert_graph_format.sh"
build_motif_logo_for_each_cluster_script=${cwd_path}"build_motif_logo_for_each_cluster_hm.sh"
cat_site_bed_cluster_script=${cwd_path}"cat_site_bed_cluster.py"
run_cat_site_bed_cluster_script=${cwd_path}"run_cat_site_bed_cluster.sh"
sort_and_merge_sites_bed_cluster_mt_script=${cwd_path}"sort_and_merge_sites_bed_cluster_mt.sh"
sort_and_merge_sites_bed_cluster_mt_big_script=${cwd_path}"sort_and_merge_sites_bed_cluster_mt_big.sh"
sort_and_merge_sites_bed_cluster_mt_big_prosampler_script=${cwd_path}"sort_and_merge_sites_bed_cluster_mt_big_prosampler.sh"
padding_merged_umotif_script=${cwd_path}"padding_merged_umotif.py"
filter_binding_sites_script=${cwd_path}"filter_binding_sites.py"
paser_prosampler_single_script=${cwd_path}"paser_prosampler_single.py"
build_umotif_database_folder_padding_30_script=${cwd_path}"build_umotif_database_folder_padding_30.sh"
paser_site_to_bed_script=${cwd_path}"paser_site_to_bed.py"
map_binding_sites_to_padding_peak_to_original_peak_script=${cwd_path}"map_binding_sites_to_padding_peak_to_original_peak.py"
convert_origin_to_tfbs_script=${cwd_path}"convert_origin_to_tfbs.py"

function convert_graph_format(){
    cp ${convert_graph_format_script} .
    pbs="run_covert_format.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash convert_graph_format.sh" >> ${pbs}
    qsub ${pbs}

}

function run_mcl_cluster(){
    pbs_header_mt='#!/bin/bash\n#PBS -l nodes=1:ppn=8\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd $PBS_O_WORKDIR'

    for inflat in 1.1 1.2 1.3 1.4 1.5
    do
	pbs="run_cluster_with_inflat_mt"${inflat}".pbs"
	output="out.ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.mci.bin.multi_threads.I"${inflat}

	#mcl ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.mci.bin -I ${inflat} -t 4 -o ${output}
	#mcxdump -icl ${output} -tabr ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.tab -o "dump."${output}".cluster"
	
	#ls ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.txt.mci.bin
	#echo -e ${pbs_header_mt} > ${pbs}
	echo -e ${pbs_header} > ${pbs}
	#echo -e "mcl ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.txt.mci.bin -I ${inflat} -t 8 -o ${output}" >> ${pbs}
	echo -e "mcxdump -icl ${output} -tabr ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.txt.tab -o dump.${output}.cluster" >> ${pbs}

	qsub ${pbs}
	#qsub ${pbs}
	#ls ${output}
	#mcxdump -icl ${output} -tabr ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.tab -o "dump."${output}".cluster"
	#wc -l "dump."${output}".cluster"
    done

}

function run_build_cluster_diff_inflat(){
    cp ${build_motif_logo_for_each_cluster_script} .
    for inflat in 1.1 #1.2 1.3 1.4 1.5
    do
	pbs="run_build_cluster_"${inflat}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash build_motif_logo_for_each_cluster_hm.sh ${inflat}" >> ${pbs}
	#qsub ${pbs}
	#bash build_motif_logo_for_each_cluster.sh ${inflat}
    done

}

function run_cat_sites_diff_inflat(){
    cp ${cat_site_bed_cluster_script} .
    cp ${run_cat_site_bed_cluster_script} .
    pbs="run_cat_site.pbs"
    #echo -e ${pbs_header} > ${pbs}
    #echo -e "bash run_cat_site_bed_cluster.sh" >> ${pbs}
    #qsub ${pbs}
    bash run_cat_site_bed_cluster.sh
    #bash run_cat_site_bed_cluster.sh
}


function run_sort_merge_bg(){
    ref=$1
    ref_size=$2

    for i in 1 #{1..2} #{3..10}
    do
	t=4
	pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=150GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    #cp ${sort_and_merge_sites_bed_cluster_mt_script} .
	    #cp ${sort_and_merge_sites_bed_cluster_mt_big_script} .
	    cp ${sort_and_merge_sites_bed_cluster_mt_big_prosampler_script} .
	    cp ${padding_merged_umotif_script} .
	    cp ${filter_binding_sites_script} .
	    cp ${paser_prosampler_single_script} .

	    pbs="run_sort_merge_padding_markov_"${cluster_folder}".just.prosampler.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    #echo -e "bash sort_and_merge_sites_bed_cluster_mt_big.sh ${cluster_folder} ${t} ${ref} ${ref_size}" >> ${pbs}
	    echo -e "bash sort_and_merge_sites_bed_cluster_mt_big_prosampler.sh ${cluster_folder} ${t} ${ref} ${ref_size}" >> ${pbs}
	    qsub ${pbs}
	    cd ../
	fi
    done




    for i in {11..600}
    do
	t=1
	pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=20GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"

	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    #cp ${sort_and_merge_sites_bed_cluster_mt_script} .
	    #cp ${padding_merged_umotif_script} .
	    #cp ${filter_binding_sites_script} .
	    #cp ${paser_prosampler_single_script} .

	    pbs="run_sort_merge_padding_markov_"${cluster_folder}".pbs"
	    #echo -e ${pbs_header} > ${pbs}
	    #echo -e "bash sort_and_merge_sites_bed_cluster_mt.sh ${cluster_folder} ${t} ${ref} ${ref_size}" >> ${pbs}
	    #qsub ${pbs}
	    #bash sort_and_merge_sites_bed_cluster_mt.sh ${cluster_folder} ${t} ${ref} ${ref_size}
	    cd ../
	fi
    done



}

<<EOF
for folder in ${human_path}
do
    human_ref="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/reference/human.fa"
    human_ref_size="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/reference/human.chrom.sizes"

    cd ${folder}
    #run_mcl
    #head ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8
    #convert_graph_format
    #run_mcl_cluster
    #run_build_cluster_diff_inflat
    for inflat in 1.1 #1.3 1.5 #1.2 1.3 1.4 1.5
    do
	folder_name="Cluster_Inflation_"${inflat}
	mkdir -p ${folder_name}
	cd ${folder_name}
	#run_cat_sites_diff_inflat
	#run_sort_merge_bg ${human_ref} ${human_ref_size}
	#run_check_unfinished
	cd ../
    done
    cd ${cwd_path}
done


for folder in ${mouse_path}
do
    mouse_ref="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/reference/mouse.fa"
    mouse_ref_size="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/reference/mouse.chrom.sizes"

    cd ${folder}
    #run_mcl
    #head ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8
    #convert_graph_format
    #run_mcl_cluster
    #run_build_cluster_diff_inflat
    for inflat in 1.1 #1.3 1.5 #1.2 1.3 1.4 1.5
    do
	folder_name="Cluster_Inflation_"${inflat}
	mkdir -p ${folder_name}
	cd ${folder_name}
	#run_cat_sites_diff_inflat
	#run_sort_merge_bg ${mouse_ref} ${mouse_ref_size}
	#run_check_unfinished
	cd ../
    done
    cd ${cwd_path}
done

EOF
function run_check_unfinished(){
    for i in {1..600}
    do
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    sort=${cluster_folder}".bed.sort"
	    if [[ ! -f ${sort} ]];then
		pbs="run_sort_merge_padding_markov_"${cluster_folder}".pbs"
		more ${pbs}
	    fi

	    cd ../
	fi
	
    done

}


function run_build_database(){
    cp ${build_umotif_database_folder_padding_30_script} .    
    pbs="run_build_umotif_database.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_umotif_database_folder_padding_30.sh" >> ${pbs}
    qsub ${pbs}

}



function run_paser_site_to_bed(){
    cp ${paser_site_to_bed_script} .  
    rm *.pbs
    rm small_patch_sites_files_*_index.txt
    for site in *8_0.sites
    do
	pbs="run_paser_site_"${site}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_site_to_bed.py ${site} 0" >> ${pbs}
	qsub ${pbs}
    done
}

function run_convert_sites_to_origin_peak(){
    inflat=$1
    merge_site_files=cluster_*.30.8.8_0.sites.bed

    #root_path="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_"${inflat}"/"

    root_path="../../../"

    cp ${map_binding_sites_to_padding_peak_to_original_peak_script} .
    for merge_site in ${merge_site_files}
    do
	cluster_index=${merge_site/".30.8.8_0.sites.bed"/}
	#cluster_100.30.8.8_0.sites.bed
	padding_to_origin=${root_path}${cluster_index}"/"${cluster_index}".bed.sort.merge.padding_30"
	origin_peak_path=${root_path}${cluster_index}"/"${cluster_index}".bed.sort.merge.clean"
	
	index=${cluster_index/"cluster_"/}
	
	if [[ ${index} -lt 10 ]];then
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=50GB\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	else
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=20GB\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	fi
	
	pbs="run_convert_sites_to_origin_peak_"${merge_site}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python map_binding_sites_to_padding_peak_to_original_peak.py ${padding_to_origin} ${origin_peak_path} ${merge_site}" >> ${pbs}
	qsub ${pbs}

    done
}


function run_check_convert_sites_to_origin_peak(){
    dataset=$1
    merge_site_files=cluster_*.30.8.8_0.sites.bed
    root_path="../../../"

    cp ${map_binding_sites_to_padding_peak_to_original_peak_script} .
    cp ${convert_origin_to_tfbs_script} .
    for merge_site in ${merge_site_files}
    do
	cluster_index=${merge_site/".30.8.8_0.sites.bed"/}

	padding_to_origin=${root_path}${cluster_index}"/"${cluster_index}".bed.sort.merge.padding_30"
	origin_peak_path=${root_path}${cluster_index}"/"${cluster_index}".bed.sort.merge.clean"
	
	index=${cluster_index/"cluster_"/}
	
	if [[ ${index} -lt 10 ]];then
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=100GB\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	else
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=50GB\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	fi
	
	origin_file=${merge_site}".origin"
	if [[ ! -f ${origin_file} ]];then
	    pbs="run_convert_sites_to_origin_peak_tfbs_"${merge_site}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python map_binding_sites_to_padding_peak_to_original_peak.py ${padding_to_origin} ${origin_peak_path} ${merge_site}" >> ${pbs}
	    echo -e "python convert_origin_to_tfbs.py ${origin_file} ${dataset}" >> ${pbs}
	    qsub ${pbs}

	fi

    done
}



function run_convert_to_origin_peak_with_tfbs(){
    dataset=$1
    origin_files=cluster_*.30.8.8_0.sites.bed.origin

    cp ${convert_origin_to_tfbs_script} .
    for origin in ${origin_files}
    do
	pbs="run_convert_origin_tf_tfbs_"${origin}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python convert_origin_to_tfbs.py ${origin} ${dataset}" >> ${pbs}
	qsub ${pbs}
    done
}


for folder in ${human_path} 
do
    cd ${folder}
    for inflat in 1.1 #1.3 1.5 #1.2 1.3 1.4 1.5
    do
	folder_name="Cluster_Inflation_"${inflat}
	cd ${folder_name}
	#run_cat_sites_diff_inflat
	#run_check_unfinished
	#run_build_database
	#mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
	cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
	#mkdir -p UMOTIF_BED_2020/
	#run_paser_site_to_bed
	cd UMOTIF_BED_2020/
	#run_convert_sites_to_origin_peak
	run_check_convert_sites_to_origin_peak human
	#run_convert_to_origin_peak_with_tfbs human

	cd ../
	cd ../../
	cd ../
    done
    cd ${cwd_path}
done


for folder in ${mouse_path}
do
    cd ${folder}
    for inflat in 1.1 #1.3 1.5 #1.2 1.3 1.4 1.5
    do
	folder_name="Cluster_Inflation_"${inflat}
	cd ${folder_name}
	#run_cat_sites_diff_inflat
	#run_check_unfinished
	#run_build_database
	#mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
	cd UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
	#mkdir -p UMOTIF_BED_2020/
	#run_paser_site_to_bed
	cd UMOTIF_BED_2020/
	#run_convert_sites_to_origin_peak
	run_check_convert_sites_to_origin_peak mouse
	#run_convert_to_origin_peak_with_tfbs mouse

	cd ../
	cd ../../
	cd ../
    done
    cd ${cwd_path}
done
