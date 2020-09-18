function run_paser_prosampler_pbs(){
    cp ${script_paser_prosampler} .
    
    small_patches=small_patch*.run_prosampler.pbs

    for small_patch in ${small_patches}
    do
	small_patch_name=${small_patch/".run_prosampler.pbs"/}
	pbs="run_paser_prosample_meme"${small_patch_name}".pbs"
	echo -e ${pbs_header} >> ${pbs}
	echo -e "python paser_prosampler.py ${small_patch_name}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_rest_paser_prosampler_pbs(){
    cp ${script_paser_prosampler} .
    
    #small_patches=small_patch*.run_prosampler.pbs
    small_patches="dataset_less_than_2_motif.txt"

    for small_patch in ${small_patches}
    do
	small_patch_name=${small_patch}
	pbs="run_paser_prosample_"${small_patch_name}".pbs"
	echo -e ${pbs_header} >> ${pbs}
	echo -e "python paser_prosampler.py ${small_patch_name}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_compute_sc_pbs(){
    cp ${script_compute_sc} .
    
    small_patches=small_patch*.run_prosampler.pbs

    for small_patch in ${small_patches}
    do
	small_patch_name=${small_patch/".run_prosampler.pbs"/}
	pbs="run_compute_sc_"${small_patch_name}".pbs"
	echo -e ${pbs_header} >> ${pbs}
	echo -e "python compute_Sc.py ${small_patch_name}" >> ${pbs}
        qsub ${pbs}
    done

}

function run_check_unrun_Sc(){
    
    cp ${script_check_unrun_Sc_script} .
    pbs="run_check_wrong.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python check_unrun_Sc.py" >> ${pbs}
    qsub ${pbs}
}

function run_plot_sc_hist(){
    cp ${script_plot_sc} .
    dataset=$1
    pbs="run_plot_sc_hist.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_Sc_dist.py ${dataset}" >> ${pbs}
    qsub ${pbs}
}

function run_rest_sc_pbs(){
    
    while IFS= read line
    do
	line_split=(`echo ${line}`)
	index=${line_split[0]}
	pbs="run_compute_sc_java_"${index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Sc ${index}" >> ${pbs}
	qsub ${pbs}
	
    done<"dataset_less_than_2_motif.txt"
}


function run_rest_sc_1_pbs(){
    
    while IFS= read line
    do
	line_split=(`echo ${line}`)
	index=${line_split[0]}
	pbs="run_compute_sc_java_"${index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Sc ${index}" >> ${pbs}
	qsub ${pbs}
	
    done<""
}




function run_compute_sc_2(){
    cp ${script_compute_sc_java} .

    javac *.java

    hard_files=*.hard

    index=0
    for hard in ${hard_files}
    do
	((++index))
	mode=$((index % 300))
	if [[ ${mode} -eq 0 ]];then
	    sleep 20m
	fi
	file_name_split=(`echo ${hard}|tr "_", " "`)
	index=${file_name_split[0]}
	#motifs=(${index}"_motif/"*".sites")
	#echo ${#motifs[@]}
	pbs="run_compute_sc_java_"${index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Sc ${index}" >> ${pbs}
        qsub ${pbs}
    done

}


function count_motif_high_sc(){
    dataset=$1
    cp ${script_count_motif_with_high_Sc_script} .
    #javac Count.java


    for t in 0.5 0.6 0.7 0.8
    do
	pbs="run_count_motif_high_sc_"${t}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Count ${dataset} ${t}" >> ${pbs}
	qsub ${pbs}

    done

}

function find_uniq(){
    cp ${script_find_uniq_motif_greater_06} .
    pbs="run_find_uniq_motif.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash find_uniq_sc_motif.sh" >> ${pbs}
    qsub ${pbs}
}

function run_convert_site_bed(){

    motif_folder=*_motif

    index=0
    for folder in ${motif_folder}
    do
	cd ${folder}
	cp ${script_convert_site_bed} .

	((++index))
	mode=$((index % 500))
	if [[ ${mode} -eq 0 ]];then
	    echo "sleep 5m"
	fi
	pbs="run_convert_site.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python convert_site_bed.py" >> ${pbs}
	qsub ${pbs}
	cd ../
    done


}

#/nobackup/zcsu_research/npy/cistrom/reference/
function convert_site_bed_fasta(){
    ref=$1
    motif_folder=*_motif

    index=0
    for folder in ${motif_folder}
    do
	cd ${folder}
	cp ${script_convert_site_bed_fa} .

	((++index))
	mode=$((index % 500))
	if [[ ${mode} -eq 0 ]];then
	    sleep 20m
	fi
	pbs="run_convert_site_bed_fa.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash convert_site_bed_fa.sh ${ref}" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
    
    

}



function count_motif_high_sc(){
    dataset=$1
    cp ${script_count_motif_with_high_Sc_script} .
    #javac Count.java


    for t in 0.6 #0.5 0.6 0.7 0.8
    do
	pbs="run_count_motif_high_sc_"${t}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Count ${dataset} ${t}" >> ${pbs}
	qsub ${pbs}

    done

}


function cat_motif_high_sc(){
    cp ${script_cat_keep_motif} .
    dataset=$1
    pbs="cat_keep_motif.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash cat_sites_fa.sh ${dataset}" >> ${pbs}
    qsub ${pbs}
}

function create_site_bed_fasta_background(){
    pbs="create_background_for_sites_fasta.pbs"
    echo -e ${pbs_header} > ${pbs}
    f_in="motif_binding_sites_Sc_greater_0.6.fa"
    f_bg="motif_binding_sites_Sc_greater_0.6.fa.bg"
    echo -e "markov -i ${f_in} -b ${f_bg} -f 5" >> ${pbs}
    qsub ${pbs}
    pwd
}

function run_build_keep_motif(){
    keep_motif=$1
    cp ${build_keep_motif_script} .
    pbs="run_build_keep_motif_script.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_keep_motif_dataset.sh ${keep_motif}" >> ${pbs}
    qsub ${pbs}
}



function run_paser_prosampler_pbs(){
    cp ${script_paser_prosampler} .
    
    small_patches=small_patch*.run_prosampler.pbs

    for small_patch in ${small_patches}
    do
	small_patch_name=${small_patch/".run_prosampler.pbs"/}
	pbs="run_paser_prosample_meme"${small_patch_name}".out.meme.pbs"
	echo -e ${pbs_header} >> ${pbs}
	echo -e "python paser_prosampler.py ${small_patch_name}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_extract_ic(){
    cp ${script_extact_ic} .
    dataset_name=$1
    pbs="run_extact_ic.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python extract_information_content.py ${dataset_name}" >> ${pbs}
    qsub ${pbs}
}


function run_merge_motif(){
    cluster_output=$1
    pbs="run_cluster_output.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "mergeMotif -i MOTIF_PSM_GT_0.6_FOLDER -s meme -o ${cluster_output} -m 30" >> ${pbs}
    qsub ${pbs}


}

function run_paser_prosampler_pbs(){
    cp ${script_paser_prosampler} .
    
    small_patches=small_patch*.pbs

    for small_patch in ${small_patches}
    do
	small_patch_name=${small_patch/".run_prosampler.pbs"/}
	pbs="run_paser_prosample_meme"${small_patch_name}".pbs"
	echo -e ${pbs_header} >> ${pbs}
	echo -e "python paser_prosampler.py ${small_patch_name}" >> ${pbs}
	qsub ${pbs}
    done
}

function run_extract_ic(){
    cp ${script_extact_ic} .
    dataset_name=$1
    pbs="run_extact_ic.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python extract_information_content.py ${dataset_name}" >> ${pbs}
    qsub ${pbs}
}

function run_compute_sc_pbs(){
    index=0
    cp ${script_compute_sc_3} .
    while IFS= read -r line
    do
	((index++))
	mode=$((${index} % 500))
	if [[ ${mode} -eq 0 ]];then
	    sleep 20m
	fi

	pbs="run_sc_v0.3_"${line}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_Sc_v0.3.py ${line}" >> ${pbs}
	qsub ${pbs}

    done<"motifs_gt_2_in_tf.txt"

}

function run_check_unrun_Sc(){
    
    cp ${script_check_unrun_Sc_script} .
    pbs="run_check_wrong.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python check_unrun_Sc.py" >> ${pbs}
    qsub ${pbs}
}

function run_compute_rest_sc_pbs(){
    index=0
    cp ${script_compute_sc_3} .
    while IFS= read -r line
    do
	((index++))
	mode=$((${index} % 500))
	if [[ ${mode} -eq 0 ]];then
	    echo "sleep 20m"
	fi

	pbs="run_sc_v0.3_rest_"${line}".m.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_Sc_v0.3.py ${line}" >> ${pbs}
	qsub ${pbs}

    done<"un_run_Sc.m.txt"

}

function run_compute_rest_sc_java_pbs(){
    index=0
    cp /nobackup/zcsu_research/npy/cistrom/Sc* .
    while IFS= read -r line
    do
	((index++))
	mode=$((${index} % 500))
	if [[ ${mode} -eq 0 ]];then
	    sleep 30m
	fi

	pbs="run_sc_v0.3_rest_java_"${line}".m.pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Sc ${line}" >> ${pbs}
	qsub ${pbs}

    done<"un_run_Sc.m.txt"

}

function merge_Sc_files(){
    type0=$1
    spices=$2
    Sc_score_name="Sc_score_${spices}_1000.${type0}.txt"
    pbs="merge_"${type0}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "rm ${Sc_score_name}" >> ${pbs}
    echo -e "cat Sc_Score_*.${type0}.txt >> ${Sc_score_name}" >> ${pbs}
    qsub ${pbs}

}

function run_plot_sc_hist(){
    cp ${script_plot_sc} .
    dataset=$1
    pbs="run_plot_sc_hist.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_Sc_dist.py ${dataset}" >> ${pbs}
    qsub ${pbs}
}


function count_motif_high_sc(){
    dataset=$1
    cp ${script_count_motif_with_high_Sc_script} .
    javac Count.java


    for t in 0.4 0.5 0.6 0.7
    do
	pbs="run_count_motif_high_sc_"${t}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "java Count ${dataset} ${t}" >> ${pbs}
	qsub ${pbs}

    done
}

