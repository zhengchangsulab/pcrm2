#!/bin/bash
cluster_bed=$1
ref="/nobackup/zcsu_research/npy/cistrom/reference/hg38.fa"

#sort -k1,1 -k2,2n ${cluster_bed} > ${cluster_bed}".sort"
rm ${cluster_bed}".sort.merge"
rm ${cluster_bed}".sort.merge.fa"
rm ${cluster_bed}".sort.merge.fa.bg"

bedtools merge -i ${cluster_bed}".sort" -c 4 -o collapse > ${cluster_bed}".sort.merge"
bedtools getfasta -fi ${ref} -bed ${cluster_bed}".sort.merge" -fo ${cluster_bed}".sort.merge.fa"
markov -i ${cluster_bed}".sort.merge.fa" -b ${cluster_bed}".sort.merge.fa.bg"
