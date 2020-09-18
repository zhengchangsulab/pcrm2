#!/bin/bash
tfbs=$1
folder_name=${tfbs}"_folder"

mkdir -p ${folder_name}

awk -v t=${tfbs} -v fn=${folder_name} '{print $0 >> fn"/"$1"_"t}' ${tfbs}
