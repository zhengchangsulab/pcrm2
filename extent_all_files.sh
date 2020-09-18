#!/bin/bash
length=$1
ref_size=$2
extend_folder=$3


files=*.bed
for f in $files
do
    python extend_peaks.py $f $length $ref_size
done

mv *filter_score_chr_${length}.bed ${extend_folder}

