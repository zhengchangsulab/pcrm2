#!/bin/bash
clusters=cluster_*/
for cluster in ${clusters}
do
    cluster_name=${cluster/"/"/}
    pbs="run_cat_"${cluster_name}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python cat_site_bed_cluster.py ${cluster_name}" >> ${pbs}
    qsub ${pbs}

done
