#!/bin/bash
cluster_name=$1
t=$2
ref=$3
ref_size=$4


cluster_bed=${cluster_name}".bed"
LC_ALL=C sort --parallel=${t} --temporary-directory=/nobackup/zcsu_research/npy/tmp/ -k1,1 -k2,2n ${cluster_bed} > ${cluster_bed}".sort"

bedtools merge -i ${cluster_bed}".sort" -c 4 -o collapse > ${cluster_bed}".sort.merge"
python filter_binding_sites.py ${cluster_bed}".sort.merge"
python padding_merged_umotif.py ${cluster_bed}".sort.merge" 30 ${ref_size}


bedtools getfasta -fi ${ref} -bed ${cluster_bed}".sort.merge.padding_30" -fo ${cluster_bed}".sort.merge.padding_30.fa"
markov -i ${cluster_bed}".sort.merge.padding_30.fa" -b ${cluster_bed}".sort.merge.padding_30.fa.bg"


ProSampler -i ${cluster_bed}".sort.merge.padding_30.fa" -b ${cluster_bed}".sort.merge.padding_30.fa.bg" -o ${cluster_name}".30.8.8" -k 8 -l 8 -t 8

if [[ -f ${cluster_name}.30.8.8.meme ]];then
    python paser_prosampler_single.py ${cluster_name}.30.8.8.meme
fi

