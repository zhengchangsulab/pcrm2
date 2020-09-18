#!/bin/bash

small_patch_files=small_patch_all_crms_300_*_index.bed

function run_compute_score(){

    cutoff_type=$1
    for small_patch in ${small_patch_files}
    do
	binding_score=${small_patch}".cre.bed.fa.score"
	#pbs="run_compute_with_cutoff_type_"${cutoff_type}"_"${small_patch}".0.n-1.pbs"
	pbs="run_compute_with_cutoff_type_"${cutoff_type}"_"${small_patch}".0.n-1.non.pbs"
	echo -e ${pbs_header} > ${pbs}
	#echo -e "python compute_crm_score_v4.py ${binding_score} ${small_patch} ${cutoff_type}" >> ${pbs}
	#echo -e "python compute_crm_score_v6_0_log.py ${binding_score} ${small_patch} ${cutoff_type}" >> ${pbs}
	#echo -e "python compute_crm_score_v7_0_pair_random.py ${binding_score} ${small_patch} ${cutoff_type}" >> ${pbs}
	echo -e "python compute_crm_score_v7_0_pair.py ${binding_score} ${small_patch} ${cutoff_type}" >> ${pbs}

	qsub ${pbs}
    done
}

function check_unrun_compute_score(){

    cutoff_type=$1
    for small_patch in ${small_patch_files}
    do
	#binding_score=${small_patch}".cre.bed.fa.score"
	pbs="run_compute_with_cutoff_type_"${cutoff_type}"_"${small_patch}".0.n-1.pbs"
	#echo -e ${pbs_header} > ${pbs}
	#echo -e "python compute_crm_score_v4.py ${binding_score} ${small_patch} ${cutoff_type}" >> ${pbs}
	#output=${small_patch}".pos_site.keep_pos_site."${cutoff_type}".score"
	output=${small_patch}".pos_site.keep_pos_site.0.n-1.score"
	if [[ ! -f ${output} ]];then
	    echo ${pbs}
	fi

    done

}

# cutoff type MEAN SIGMA_1 SIGMA_2
run_compute_score MEAN
#check_unrun_compute_score MEAN

#######################################
# cutoff type SIGMA_3, SIGMA_4
#run_compute_score SIGMA_4
#check_unrun_compute_score SIGMA_4
