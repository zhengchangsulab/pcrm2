#!/bin/bash
ref_genome=$1
files=*_sort.bed

if [[ -f run_convert_bed_to_fasta.sh ]];then
    rm -f run_convert_bed_to_fasta.sh
fi

for f in $files
do

    echo -e "bedtools getfasta -fi $ref_genome -bed $f -fo ${f}.fa" >> run_convert_bed_to_fasta.sh
    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.sh" run_convert_bed_to_fasta.sh small_patch_convert_to_fasta_

    
done
