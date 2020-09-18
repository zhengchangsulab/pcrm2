#!/bin/bash
small_patch=$1
reference="/nobackup/zcsu_research/npy/cistrom/reference/hg38.fa"

while IFS= read -r sites_bed
do
    sites_bed_path="../SITES_BED/"${sites_bed}".bed"
    bedtools getfasta -fi ${reference} -bed ${sites_bed_path} -fo ${sites_bed}".fa" -name
done<${small_patch}
