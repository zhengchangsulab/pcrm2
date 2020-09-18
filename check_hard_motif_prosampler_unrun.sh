#!/bin/bash
cwd=$(pwd)
for dataset in TF_human #TF_mouse
do
    for length in 1000 1500 3000
    do

	folder="./${dataset}/${dataset}_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_${length}/Sorted_Bed/Fasta_File/Hard_Fasta_File/"
	cd ${folder}
	echo "-----------------------------------------"
	fa_hard=*.bed.fa.hard
	for file in ${fa_hard}
	do
	    result=${file}.prosampler.txt.spic
	    if [[ ! -f ${result} ]];then
		output=${file}.prosampler.txt
		pbs=${file}.run_prosampler.pbs
		echo -e ${pbs_header} > ${pbs}
		echo -e "time ProSampler -i ${file} -b ${file}.markov.bg -o ${output}" >> ${pbs}
		qsub ${pbs}
		#pbs=${file}.run_markov.pbs
		#echo -e ${pbs_header_cobra} > ${pbs}
		#echo -e "markov -i ${file} -b ${file}.markov.bg" >> ${pbs}
		#qsub ${pbs}
	    fi
 
	done
	echo "-----------------------------------------"
	cd ${cwd}
    done
done
