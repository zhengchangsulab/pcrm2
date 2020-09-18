#!/bin/bash
files=*filter_score_chr_*.bed
for f in $files
do
    sort -V -k1,1 -k2,2n $f > ${f/".bed"/"_sort.bed"}
done

rm -rf Sorted_Bed
mkdir Sorted_Bed
mv *_sort.bed Sorted_Bed
