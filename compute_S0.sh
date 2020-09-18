#!/bin/bash

a_file=$1

so_file=${a_file}".overlap_with_others.txt"

if [[ -f ${so_file} ]];then
    rm ${so_file}
fi

files=(*.bed)

for f in ${files[@]}
do
    overlap=(`bedtools intersect -u -a ${a_file} -b ${f}|wc -l`)
    f_i_index=(`echo ${a_file}|tr "_" " "`)
    f_j_index=(`echo ${f}|tr "_" " "`)

    echo "${f_i_index}|${f_j_index}:${overlap}" >> ${so_file}
done
