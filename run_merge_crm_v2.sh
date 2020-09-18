#!/bin/bash

for length in 300 #150 200 250 300 #350 400 450 500                                                                                                                                                                                           
do

    mkdir -p "CRM/crm_"${length}
    for f in chr6_KEEP_BINDING_SITES.bed.sort.uniq chr7_KEEP_BINDING_SITES.bed.sort.uniq chr8_KEEP_BINDING_SITES.bed.sort.uniq
    do
        pbs="run_merge_crm_"${f}"."${length}".pbs"
        echo -e ${pbs_header} > ${pbs}
        echo -e "bedtools merge -i ${f} -d ${length} -c 4 -o collapse > CRM/crm_"${length}"/${f}.${length}.crm" >> ${pbs}
        qsub ${pbs}
        #bedtools merge -i ${f} -d ${length} -c 4 -o collapse > CRM/crm_"${length}"/${f}.${length}.crm                                                                                                                                        
    done


done
