#!/bin/bash
while IFS= read -r line
do
    error_file=(`find UMOTIF_BINDING_SITES_PEAK_FOLDER_*_1000_0.7 -name "run_get_closest_dist.pbs.e"${line}`)
    unfinished_folder=$(dirname ${error_file})
    echo ${unfinished_folder}
done<"Jobs_c.txt"
