#!/bin/bash
output_file=$1

if [[ -f motif_number.txt ]];then
    rm motif_number.txt
fi


meme_files=*.meme
for meme in ${meme_files}

do
    tf_index=(`echo ${meme}|tr "_" " "`)
    motif_number=(`ls ${tf_index}"_motif/"*.sites|wc -l`)
    echo -e ${tf_index}"\t"${motif_number} >>  motif_number.txt
done

sort -n k2 motif_number.txt > ${output_file}
