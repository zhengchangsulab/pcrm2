#!/bin/bash

origin_1="cluster_3.30.8.8_0.sites.bed.origin.origin_peak.sort"
origin_index_1=${origin_1/".30.8.8_0.sites.bed.origin.origin_peak.sort"/}


origin_files="cluster_14.30.8.8_0.sites.bed.origin.origin_peak.sort"  #cluster_*.30.8.8_0.sites.bed.origin.origin_peak.sort


for origin_2 in ${origin_files}
do
    origin_index_2=${origin_2/".30.8.8_0.sites.bed.origin.origin_peak.sort"/}

    if [[ ${origin_1} != ${origin_2} ]];then
	bedtools intersect -a ${origin_1} -b ${origin_2} -wa -f 1 -sorted > ${origin_index_1}"/"${origin_index_1}"-"${origin_index_2}".overlap"
    fi
done 
