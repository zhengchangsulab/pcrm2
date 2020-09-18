#!/bin/bash
filter () 
{

    filter_folder=${folder}"_"${threhold_1}"_"${threhold_2}"_"${threhold_3}"_"${threhold_4}"_"${threhold_5}"_filter_bed_2"
    if [ ! -d $filter_folder ];then
	mkdir $filter_folder
    fi

    files=*.bed
    
    filter_files_sequence_number=${filter_folder}"_sequence_number.txt"

    for f in $files
    do
	total_number=$(more $f|wc -l)
	
	filter_file=${f/.bed/.filter.bed}
	if [[ $total_number -lt 1000 ]];then
	    awk '$5 > 20 {print}' $f > $filter_file
	elif [[ ($total_number -gt 1000) && ($total_number -lt 10000) ]]; then
	    awk '$5 > 20 {print}' $f > $filter_file
	elif [[ ($total_number -gt 10000) && ($total_number -lt 100000) ]]; then
	    awk '$5 > 20 {print}' $f > $filter_file
	elif [[ ($total_number -gt 100000) && ($total_number -lt 1000000) ]]; then
	    awk '$5 > 350 {print}' $f > $filter_file
	else
	    awk '$5 > 350 {print}' $f > $filter_file
	fi
	
	more $filter_file|wc -l >> $filter_files_sequence_number
	mv $filter_file $filter_folder
    done
    
    sort -n $filter_files_sequence_number > ${filter_files_sequence_number/.txt/.sort.txt}
    rm $filter_files_sequence_number

}
folder=$1

cd $folder
filter
cd ../




