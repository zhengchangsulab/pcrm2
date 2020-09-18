#!/bin/bash
input=$1
t=$2
ref=$3
ref_size=$4

while IFS= read -r line
do
    bash sort_and_merge_sites_bed_cluster_mt.sh ${line} $
done<${input}
