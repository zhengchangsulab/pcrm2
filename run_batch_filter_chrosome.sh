#!/bin/bash
small_patch=$1
while IFS= read -r line
do
    python filter_chrosome.py ${line}
    output=${line}".chr"
    total_number=$(cat ${output}|wc -l)
    echo ${total_number}
    if [[ $total_number -lt 100000 ]];then
	awk '$5 > 20 {print}' ${output} > ${output}".filter"
    else
	awk '$5 > 350 {print}' ${output} > ${output}".filter"
    fi
done<${small_patch}
