#!/bin/bash
cwd="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"
script="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/run_compute_closest_tfbs_distance_v2.sh"

folders=(`more unfinished_dist_folders.txt`)

#0..57
for i in {46..50} #F:0-5 6-10 11-15 16-20 21-25 26-30 31-35 36-40 41-45
do
    folder=${folders[i]}
    cd ${folder}
    cp ${script} .
    bash run_compute_closest_tfbs_distance_v2.sh
    cd ${cwd}
    #echo ${folders[i]}
done


