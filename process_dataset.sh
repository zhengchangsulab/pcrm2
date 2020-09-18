#!/bin/bash
cwd=$(pwd)
count_script="/nobackup/zcsu_research/npy/cistrom/count_sequence_number.sh"
count_peak_script="/nobackup/zcsu_research/npy/cistrom/count_peak_length.sh"
count_overlap_script="/nobackup/zcsu_research/npy/cistrom/compute_S0.sh"
compute_s0_script="/nobackup/zcsu_research/npy/cistrom/paser_S0.py"
build_keep_motif_script="/nobackup/zcsu_research/npy/cistrom/build_keep_motif_dataset.sh"

function run_count(){
    cp ${count_script} .
    output=$1
    pbs="run_count.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_sequence_number.sh ${output}" >> ${pbs}
    qsub ${pbs}
}

function run_count_peak_length(){
    cp ${count_peak_script} .
    output=$1
    pbs="run_count_peak_length.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_peak_length.sh ${output}" >> ${pbs}
    qsub ${pbs}
}



index=0
function run_compute_overlap(){
    cp ${count_overlap_script} .

    bed_files=*.bed
    for bed in ${bed_files}
    do
	pbs="run_compute_overlap_"${bed}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_S0.sh ${bed}" >> ${pbs}
	qsub ${pbs}
	((index++))

	mode=$((${index}%500))

	if [[ ${mode} -eq 0 ]];then
	    sleep 30m
	fi
    done
}

function run_compute_so(){
    cp ${compute_s0_script} .

    tf_number_file=$1
    pbs="run_compute_so.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python paser_S0.py ${tf_number_file}" >> ${pbs}
    qsub ${pbs}

}

function run_build_keep_motif(){
    keep_motif=$1
    cp ${build_keep_motif_script} .
    pbs="run_build_keep_motif_script.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_keep_motif_dataset.sh ${keep_motif}" >> ${pbs}
    qsub ${pbs}
}

human="TF_human"

cd ${human}
cd "TF_human_raw_peak"
#run_count TF_human_raw_peak_number.txt
#run_count_peak_lengt TF_human_raw_peak_length.txt
#run_compute_overlap
#cp TF_human_raw_peak_number.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
#cp TF_human_raw_peak_length.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
cd "../TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/"
#run_count TF_human_filter_peak_number.txt
#run_count_peak_length TF_human_filter_peak_length.txt
#run_compute_overlap
#cp TF_human_filter_peak_number.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
#cp TF_human_filter_peak_length.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
#run_compute_so TF_human_filter_peak_number.txt
#run_build_keep_motif Sc_score_human_1000_0.6.keep_motif.txt
cd "./extend_to_1000/Sorted_Bed/"
#run_count_peak_length TF_human_filter_extend_1000_peak_length.txt
#run_compute_overlap
#run_count TF_human_filter_peak_number.txt
run_compute_so TF_human_filter_peak_number.txt
#cp TF_human_filter_extend_1000_peak_length.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats

cd ${cwd}



mouse="TF_mouse"
cd ${mouse}
cd "TF_mouse_raw_peak"
#run_count TF_mouse_raw_peak_number.txt
#run_count_peak_length TF_mouse_raw_peak_length.txt
#run_compute_overlap
#cp TF_mouse_raw_peak_number.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
#cp TF_mouse_raw_peak_length.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats

cd "../TF_mouse_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/"
#run_count TF_mouse_filter_peak_number.txt
#run_count_peak_length TF_mouse_filter_peak_length.txt
#run_compute_overlap
#cp TF_mouse_filter_peak_number.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
#cp TF_mouse_filter_peak_length.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
#run_compute_so TF_mouse_filter_peak_number.txt
#run_build_keep_motif Sc_score_mouse_1000_0.6.keep_motif.txt
cd "./extend_to_1000/Sorted_Bed/"
#run_count_peak_length TF_mouse_filter_extend_1000_peak_length.txt
#run_count TF_mouse_filter_peak_number.txt
#run_compute_overlap
#cp TF_mouse_filter_extend_1000_peak_length.txt /nobackup/zcsu_research/npy/cistrom/Dataset_Stats
run_compute_so TF_mouse_filter_peak_number.txt
cd ${cwd}








