#!/bin/bash
overlap_files=cluster_*.overlap

for overlap in ${overlap_files}
do
    overlap_split=(`echo ${overlap/.overlap/}|tr "-" " "`)
    overlap_pair="../"${overlap_split[1]}"/"${overlap_split[1]}"-"${overlap_split[0]}".overlap"
    
    if [[ -s ${overlap} || -s ${overlap_pair} ]];then
	#du -h ${overlap_pair}
	pbs="run_resubmit_unfinished_"${overlap}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_closest_tfbs_distance.py ${overlap}" >> ${pbs}
	qsub ${pbs}
    else
	touch ${overlap}.dist
    fi

    #python compute_closest_tfbs_distance.py ${overlap}
done
