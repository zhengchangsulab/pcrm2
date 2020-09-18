#!/bin/bash
overlap_files=cluster_*.overlap
for overlap in ${overlap_files}
do

    overlap_split=(`echo ${overlap/.overlap/}|tr "-" " "`)
    pair_overlap="../"${overlap_split[1]}"/"${overlap_split[1]}"-"${overlap_split[0]}".overlap"
    compute_closest_tfbs_distance_v3 ${overlap} ${pair_overlap}
    #python compute_closest_tfbs_distance.py ${overlap}
done
