#!/bin/bash
cwd="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"
script="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/run_compute_closest_tfbs_distance_unfinished_c.sh"
script_v2="/nobackup/zcsu_research/npy/All_In_One_CRM_Project/run_compute_closest_tfbs_distance_unfinished_c_v2.sh"
#folders=(`more unfinished_get_dist_folders.txt`)
folders=(`more left_mouse_dist.txt`)
for i in {0..1} #{0..34} #{16..34} #{7..15} #{0..6} #{0..34}
do
    folder=${folders[i]}
    cd ${folder}
    cp ${script} .
    #bash run_compute_closest_tfbs_distance_unfinished_c.sh
    pbs="run_check_stop.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash run_compute_closest_tfbs_distance_unfinished_c_v2.sh" >> ${pbs}
    qsub ${pbs}
    
    cd ${cwd}
done


