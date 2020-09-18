#!/bin/bash
cluster_clean_files=cluster*sites.bed.sort.merge.clean

for cluster_clean_file in ${cluster_clean_files}
do
    cluster_name=${cluster_clean_file/"_0.sites.bed.sort.merge.clean"/}
    cluster_path="../../../../CLUSTER_BED_MERGE/"${cluster_name}".bed.sort.merge.clean"
    size=(`du ${cluster_path}`)


    min_mem=$((8388608/40))
    
    if [[ ${size} -lt ${min_mem} ]];then
        mem=20GB
    else
        c=$(bc <<< "scale=1; ${size}/1048576*40")
	mem=$((${c%.*}*3+20))"GB"
    fi

    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
    pbs="run_convert_sites_to_origin_peak_"${cluster_clean_file}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python map_binding_sites_to_original_peak.py ${cluster_path} ${cluster_clean_file}" >> ${pbs}
    qsub ${pbs}
done
