#!/usr/bash
dist_files=cluster*.dist.c
for dist in ${dist_files}
do
    if [[ -s ${dist} ]];then
	python convert_tfbs_format_v3.py ${dist}
	#bash run_split_tfbs.sh ${dist}.tfbs
    fi

done
