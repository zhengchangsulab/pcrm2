#!/bin/bash
origin_peak_1=$1
others_origin_files=*merge.clean.origin.gt_2.origin_bed.pos
for origin_peak_2 in ${others_origin_files}
do
    
    if [[ "${origin_peak_1}" != "${origin_peak_2}" ]];then
	output_overlap=${origin_peak_1}"-"${origin_peak_2}".overlap"
	bedtools intersect -a ${origin_peak_1} -b ${origin_peak_2} -wa -f 0.8 -r -u > ${output_overlap}
    fi
done
