#!/bin/bash
big_files=(`find . -maxdepth 1 -name "cluster*.overlap" -size +1024M`)
for f in ${big_files[@]}
do
    f_name=$(basename ${f})
    #lfs migrate -c2 ${f_name}
    info=(`lfs getstripe ${f_name}|head -2|tail -1`)
    count=${info[1]}
    if [[ "${count}" -ne 2 ]];then

	pbs="run_strip_"${f_name}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "lfs migrate -c10 ${f_name}" >> ${pbs}
	qsub ${pbs}

    fi
    #echo ${f_name}
done


big_files=(`find . -maxdepth 1 -name "cluster_*.overlap" -size +500M -size -1024M`)
for f in ${big_files[@]}
do
    f_name=$(basename ${f})
    #lfs migrate -c2 ${f_name}
    info=(`lfs getstripe ${f_name}|head -2|tail -1`)
    count=${info[1]}
    if [[ "${count}" -ne 2 ]];then

	pbs="run_strip_"${f_name}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "lfs migrate -c5 ${f_name}" >> ${pbs}
	qsub ${pbs}
    fi
    #echo ${f_name}
done

