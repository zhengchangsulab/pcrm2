#!/bin/bash
cwd="/nobackup/zcsu_research/npy/All_In_One_CRM_Project"
for s in ce dap human mouse
do
    folder_sites=${s}"_factor/Sorted/extend_1000/Hard_Mask/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_1.1/UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES/UMOTIF_BED_2020/"
    folder_origin_peaks="UMOTIF_BINDING_SITES_PEAK_FOLDER_"${s}"_1000_0.7/UMOTIF_BED_MERGE_Origin_Peak/"

    cd ${folder_sites}
    ls *.bed|wc -l
    cd ${cwd}

    cd ${folder_origin_peaks}
    ls *origin_peak|wc -l
    cd ${cwd}
done
