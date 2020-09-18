#!/bin/bash
error_files=(`find UMOTIF_BINDING_SITES_PEAK_FOLDER_*_1000_0.7 -name "run_get_closest_dist.pbs*.e*" -size +0`)
cwd="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"

for error in ${error_files[@]}
do
    error_file=$(basename ${error})
    error_path=$(dirname ${error})
    cd ${error_path}
    output=${error_file/".pbs.e"/".pbs.o"}
    pbs=(`echo ${output}|rev|cut -d"." -f2-|rev`)

    #sed -i -e "s/mem=8GB/mem=20GB/" -e "s/walltime=8/walltime=100/" ${pbs}
    qsub ${pbs}

    rm ${error_file}
    rm ${output}
    cd ${cwd}
done
