#!/bin/bash
function create_background_pbs_dinucl {
    for f in TF_human TF_mouse
    do
	file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_3000_sort/3000_fa_file"
	current_folder=$(pwd)

	cp fasta-dinucleotide-shuffle.py $file_path
	cp sequence.py $file_path
	cp create_generate_background.sh $file_path
	
	cd $file_path

	smalls=$(ls small*)
	if [[ ${#smalls[@]} -gt 0 ]];then
	    rm small*
	fi

	bgs=$(ls *.hard.fa.bg)
	if [[ ${#bgs[@]} -gt 0 ]];then
	    rm *.hard.fa.bg
	fi

	ls *.hard.fa > file_name_index
	split -l 8 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_hard_

	small_patch_files=small_hard_*
	for s in $small_patch_files
	do
	    pbs=${s}.pbs
	    echo -e $pbs_header > $pbs
	    echo -e "bash create_generate_background_markov.sh $s" >> $pbs
	    more $pbs
	done
	cd $current_folder
    done
}


function create_background_pbs_markov {
    for f in TF_human TF_mouse
    do
	file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_3000_sort/3000_fa_file"
	current_folder=$(pwd)

	cp split_small_patches.py $file_path
	cp create_generate_background_markov.sh $file_path
	cd $file_path

	smalls=$(ls small*)
	if [[ ${#smalls[@]} -gt 0 ]];then
	    rm small*
	fi

	if [[ ! -d di_nucl_bg ]];then
	    mkdir di_nucl_bg
	    mv *hard.fa.bg di_nucl_bg
	fi

	du *.hard.fa > file_name_index
	python split_small_patches.py file_name_index 700 small_patch
	small_patch_files=small_patch*
	for s in $small_patch_files
	do
	    pbs=${s}.pbs
	    echo -e $pbs_header > $pbs
	    echo -e "bash create_generate_background_markov.sh $s" >> $pbs
	    qsub $pbs
	done
	cd $current_folder
    done
}


function create_background_rest_pbs_markov {
    for f in TF_human TF_mouse
    do
	file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_3000_sort/3000_fa_file"
	current_folder=$(pwd)

	cp split_small_patches.py $file_path
	cp create_generate_background_markov.sh $file_path
	cd $file_path


	rest=${f}.no_background_files
	if [[ -f $rest ]];then
	    files=$(more $rest)
	    for fil in $files
	    do
		pbs=${fil}.rest.pbs
		echo -e $pbs_header > $pbs
		echo -e "markov -i ${fil} -b ${f}.markov.bg" >> $pbs
		qsub $pbs
	    done
	fi
	cd $current_folder
    done
}
create_background_rest_pbs_markov



