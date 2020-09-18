#!/bin/bash
files=*chr.filter.sort.extend_1000 #*chr.filter.sort

cat_file_name="TF_all_sort_motifs_unmerge.1000.bed.cat.clean"

if [[ -f ${cat_file_name} ]];then
    rm -f ${cat_file_name}
fi

for f in ${files}
do
    awk '{print $1"\t"$2"\t"$3}' ${f} >> ${cat_file_name}
done
LC_ALL=C sort -k1,1 -k2,2n --parallel=8 ${cat_file_name} > ${cat_file_name}".sort"
bedtools merge -i ${cat_file_name}".sort" > ${cat_file_name}".sort.merge"
python count_total_bp.py ${cat_file_name}".sort.merge"
