#!/bin/bash
output=$1

if [[ -f sequence_number.txt ]];then
    rm sequence_number.txt
fi


files=*.bed
for f in $files
do
    wc -l $f >> sequence_number.txt
done

sort -n -k1 sequence_number.txt > ${output}
