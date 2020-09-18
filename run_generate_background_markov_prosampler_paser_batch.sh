#!/bin/bash
files_name=$1
while IFS= read -r line
do
    markov -i ${line} -b ${line}.markov.bg
    output=${line}.prosampler.txt
    ProSampler -i ${line} -b ${line}.markov.bg -o ${output}
    python paser_prosampler_single.py ${output}".meme"

done<"$files_name"
