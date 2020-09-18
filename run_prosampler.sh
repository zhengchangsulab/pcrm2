#!/bin/bash
file_name=$1

while IFS= read -r line
do

    output=${line}.prosampler.txt
    time ProSampler -i ${line} -b ${line}.markov.bg -o ${output}
done<"$file_name"


