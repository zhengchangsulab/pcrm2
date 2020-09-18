#!/bin/bash
output=$1
files=*.bed

if [[ -f peak_length.txt ]];then
    rm peak_length.txt
fi

for f in ${files}
do
    awk '{print $3-$2}' ${f} >> peak_length.txt
done

sort -n -k1 peak_length.txt > ${output} 
