#!/bin/bash
overlap_files=cluster_*.overlap
for overlap in ${overlap_files}
do
    if [[ ! -f ${overlap}.dist.c ]];then
	if [[ -s ${overlap} ]];then
	    overlap_split=(`echo ${overlap/.overlap/}|tr "-" " "`)
	    pair_overlap="../"${overlap_split[1]}"/"${overlap_split[1]}"-"${overlap_split[0]}".overlap"
	    pbs="run_unfinished_dist_"${overlap}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "compute_closest_tfbs_distance_v3 ${overlap} ${pair_overlap}" >> ${pbs}
	    more ${pbs}
	else
	    cp ${overlap} ${overlap}".dist.c"

	fi

    fi
done
