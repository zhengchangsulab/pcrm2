#!/bin/bash
chrom_files=chr*_KEEP_BINDING_SITES.bed  #ALL_150.CRM_count_*.crm.cre
for chrom in ${chrom_files}
do
    pbs="run_sort_uniq_"${chrom}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "LC_ALL=C sort -k1,1 -k2,2n ${chrom} > ${chrom}.sort" >> ${pbs}
    echo -e "uniq ${chrom}.sort > ${chrom}.sort.uniq" >> ${pbs}
    qsub ${pbs}
done
