#!/bin/bash
overlap_files=cluster_*.overlap
for overlap in ${overlap_files}
do

    if [[ -s ${overlap} ]];then
	overlap_split=(`echo ${overlap/.overlap/}|tr "-" " "`)
	pair_overlap="../"${overlap_split[1]}"/"${overlap_split[1]}"-"${overlap_split[0]}".overlap"
	
	dist_c_number=(`wc -l ${overlap}.dist.c`)
	overlap_number=(`wc -l ${overlap}`)
	echo ${dist_c_number}":"${overlap_number}

	if [[ ${dist_c_number} -ne ${overlap_number} ]];then
	    pbs="run_unfinished_dist_stop_"${overlap}".pbs"
	    #echo -e ${pbs_header} > ${pbs}
	    #echo -e "compute_closest_tfbs_distance_v3 ${overlap} ${pair_overlap}" >> ${pbs}
	    #echo ${pbs}
	    compute_closest_tfbs_distance_v3 ${overlap} ${pair_overlap}
	    echo ${overlap}
	fi
	
    else
	    #cp ${overlap} ${overlap}".dist.c"
	:
    fi
done
