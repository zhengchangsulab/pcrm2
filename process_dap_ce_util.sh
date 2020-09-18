function run_mcl(){
    #cp ${keep_edges_gt_script} .
    #pbs="run_keep_edges_gt_0.8.pbs"
    #echo -e ${pbs_header} > ${pbs}
    #echo -e "bash keep_edges_gt_0.8.sh ALL_KEEP_MOTIF_PAIR_SPIC_SCORE" >> ${pbs}
    #qsub ${pbs}
    :
}

function convert_graph_format(){
    cp ${convert_graph_format_script} .
    pbs="run_covert_format.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash convert_graph_format.sh" >> ${pbs}
    qsub ${pbs}

}


function run_mcl_cluster(){
    pbs_header_mt='#!/bin/bash\n#PBS -l nodes=1:ppn=4\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd $PBS_O_WORKDIR'

    for inflat in 1.1 1.2 1.3 1.4 1.5
    do
	pbs="run_cluster_with_inflat_mt"${inflat}".pbs"
	output="out.ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.mci.bin.multi_threads.I"${inflat}
	
	#echo -e ${pbs_header_mt} > ${pbs}
	#echo -e "mcl ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.mci.bin -I ${inflat} -t 4 -o ${output}" >> ${pbs}
	#qsub ${pbs}
	#ls ${output}
	#mcxdump -icl ${output} -tabr ALL_KEEP_MOTIF_PAIR_SPIC_SCORE.GT_0.8.tab -o "dump."${output}".cluster"
	#wc -l "dump."${output}".cluster"
    done

}

function run_build_cluster_diff_inflat(){
    cp ${build_motif_logo_for_each_cluster_script} .
    for inflat in 1.1 1.2 1.3 1.4 1.5
    do
	pbs="run_build_cluster_"${inflat}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash build_motif_logo_for_each_cluster.sh ${inflat}" >> ${pbs}
	qsub ${pbs}
    done

}

function run_cat_sites_diff_inflat(){
    cp ${cat_site_bed_cluster_script} .
    cp ${run_cat_site_bed_cluster_script} .
    pbs="run_cat_site.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_cat_site_bed_cluster.sh" >> ${pbs}
    qsub ${pbs}
}

function run_sort_merge_bg(){
    ref=$1
    ref_size=$2

    for i in {1..10}
    do
	t=4
	pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=4,mem=32GB\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\ncd \$PBS_O_WORKDIR"
	cluster_folder="cluster_"${i}
	if [[ -d ${cluster_folder} ]];then
	    cd ${cluster_folder}
	    cp ${sort_and_merge_sites_bed_cluster_mt_script} .
	    cp ${padding_merged_umotif_script} .
	    cp ${filter_binding_sites_script} .
	    cp ${paser_prosampler_single_script} .

	    pbs="run_sort_merge_padding_markov_"${cluster_folder}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bash sort_and_merge_sites_bed_cluster_mt.sh ${cluster_folder} ${t} ${ref} ${ref_size}" >> ${pbs}
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
	    cp ${sort_and_merge_sites_bed_cluster_mt_script} .
	    cp ${padding_merged_umotif_script} .
	    cp ${filter_binding_sites_script} .
	    cp ${paser_prosampler_single_script} .

	    pbs="run_sort_merge_padding_markov_"${cluster_folder}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bash sort_and_merge_sites_bed_cluster_mt.sh ${cluster_folder} ${t} ${ref} ${ref_size}" >> ${pbs}
	    qsub ${pbs}
	    cd ../
	fi
    done



}

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

