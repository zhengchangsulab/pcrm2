#!/bin/bash
while IFS= read -r line
do
    pbs="run_bg_prosampler_pasar_"${line}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "markov -i ${line} -b ${line}.markov.bg" >> ${pbs}
    echo -e "output=${line}.prosampler.txt" >> ${pbs}
    echo -e "ProSampler -i ${line} -b ${line}.markov.bg -o \${output}" >> ${pbs}
    echo -e "python paser_prosampler_single.py \${output}.meme" >> ${pbs}
    qsub ${pbs}
done<"left_unfinished_list"
