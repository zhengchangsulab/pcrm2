#!/bin/bash
small_batch=$1
ref_genome=$2

while IFS= read -r line
do
    bedtools getfasta -fi ${ref_genome} -bed ${line} -fo ${line}".fa"
    python hard_mask.py ${line}".fa"
done<${small_batch}
