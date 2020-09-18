#!/bin/bash
small_files=small_patch_all_crms_300_*_index.bed

for small in ${small_files}
do
    pbs="run_extract_score_"${small}".pbs"
    output=${small}".cre.bed.fa.score"
    if [[ ! -f ${output} ]];then
	echo -e ${pbs_header} >${pbs}
	fasta_peak_name=${small}".fa"
	echo -e "python extract_cre_sequences.py ${fasta_peak_name} ${small}" >> ${pbs}
	qsub ${pbs}

    fi


done
