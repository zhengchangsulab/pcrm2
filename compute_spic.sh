#!/bin/bash

function compute_spic_for_motif_with_rest(){
    input_motif=$1

    pair_motifs=(`more ${input_motif}".with_pair"`)
    
    output=${input_motif}".spic_with_other.results"
    
    if [[ -f ${output} ]];then
	rm ${output}
    fi
    
    for pair_motif in ${pair_motifs[@]}
    do
	spic ${input_motif} ${pair_motif} >> ${output}
    done
}


small_patch_file=$1
input_motifs=(`more ${small_patch_file}`)
for input_motif in ${input_motifs[@]}
do
    compute_spic_for_motif_with_rest ${input_motif}
done
