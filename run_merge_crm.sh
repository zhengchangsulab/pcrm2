#!/bin/bash
files=chr*_KEEP_BINDING_SITES.bed.sort.uniq


for length in 150 300 #350 400 450 500
do

    mkdir -p "CRM/crm_"${length}
    for f in ${files}
    do
	pbs="run_merge_crm_"${f}"."${length}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bedtools merge -i ${f} -d ${length} -c 4 -o collapse > CRM/crm_"${length}"/${f}.${length}.crm" >> ${pbs}
	qsub ${pbs}
	#bedtools merge -i ${f} -d ${length} -c 4 -o collapse > CRM/crm_"${length}"/${f}.${length}.crm
    done


done
