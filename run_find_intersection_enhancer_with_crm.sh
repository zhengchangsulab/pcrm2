#!/bin/bash
#crm_path="/projects/zcsu_research/npy/CO_OCCUR/Network_Anlysis/POST_ANALYSIS/CONSERVATION_AND_RECOVERY_ANALYSIS/CRM_CUT_0.49_POS.bed.merge"
#crm_path="CRMs_final.clean.hg38"
#crm_path="CRM_500_0.49_0.58_SHORT.bed"
#crm_path="total_binding_sites.bed.clean.sort.merge"
#crm_pathes="cluster_103-cluster_104*.overlap.clean"
#crm_pathes=""
#crm_pathes="cluster_103*no_dataset.overlap"
#crm_path="TF_all_sort_motifs.1500.bed.cat.sort.clean.merge"
#crm_path="CRE_total_un_coding.sort.merge"
#random_peak_un_overlap_with_crm_path="/projects/zcsu_research/npy/CO_OCCUR/Network_Anlysis/POST_ANALYSIS/CONSERVATION_AND_RECOVERY_ANALYSIS/CRM_CUT_0.49_POS.bed.merge.REST_1500.random_crm"
#enhancers=*.hg38.overlap_with_tf_extend_peak

enhancer="vista_enhancer_hg19.bed.hg38.overlap_with_tf_extend_peak"
crms="ALL_150.CRM_count_1200.crm.cre" #"ALL_150.CRM" #"total_clean.crm" #cluster_142.8_0.sites.bed.sort.merge.clean.origin.origin_peak.sort.uniq #"cluster_142-cluster_146.overlap.origin.clean.sort.uniq"

for crm in ${crms} #cluster_1003-cluster_1017.overlap.origin.clean.sort.uniq #cluster_1-cluster_360.overlap.origin.clean #cluster_739-cluster_40.overlap.origin.clean #${crm_pathes}
do
    #bedtools intersect -a ${enhancer} -b ${crm} -wa -u > ${enhancer}"-"${crm}".keep_peak"
    bedtools intersect -a ${crm} -b ${enhancer} -wa -u > ${crm}"-"${enhancer}".keep_enhancer"
done
