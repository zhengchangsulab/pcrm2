#!/bin/bash
files_name=$1
while IFS= read -r line
do
    name_split=(`echo ${line}|tr "." " "`)
    index=${name_split[0]}
    python compute_Sc_v0.3.py ${index}
done<"$files_name"
