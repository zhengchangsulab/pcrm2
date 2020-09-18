#!/bin/bash
small_batch=$1
ext_length=$2
ref_size=$3

while IFS= read -r line
do
    python extend_peaks.py ${line} ${ext_length} ${ref_size}

done<${small_batch}
