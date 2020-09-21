# DePCRM2
This pipeline is mainly implemented using shell, python, require bedtools, bedops, matplotlib, Prosampler, SPIC.  

# The script preprocess_2020.sh runs the following steps
# step 1: dataset preprocessing
## (1) extend peaks into 1000 bps for all datasets.
### 1) uncomment "sort_bed" function to sort all datasets. 
### 2) uncomment "run_extend_peak 1000 ${folder}" function to extend all dataset into 1000 bps.

# step 2: Motifs indentification
## 1)uncomment "run_get_fasta_and_hard_mask" function to convert bed to fasta format, and hard mash the repetitive regions, this step needs "run_get_fasta_and_hard_mask_batch.sh", "hard_mask.py"
## 2)uncomment "run_markov_bg_prosampler" function to generate the background sequences for fasta dataset, and run prosampler to find motifs in all datasets, this teps needs "markov" "ProSampler".
# step 3: Sc score computation
## 1)uncomment "run_compute_sc_batch" function to compuate Sc score in each dataset, this step need run_compute_sc_batch.sh, compute_Sc_v0.3.py script.
## 2)uncomment "run_move_keep_motif_spic 0.7" function to move all motifs whose Sc score is greater than cutoff>=0.7 (default) into one folder

# The script process_human_mouse.sh runs the following steps
# step 4: Umotif identification
## 1) compute SPIC for all pairs of motifs kept from last step using "SPIC" command. 
## 2) keep motifs whose SPIC score greater than 0.8 (default), and create a motif1\tmotif2\tSPIC_score format file to construct the similary networks.
## 3) uncomment "run_mcl_cluster" function to partition the network into small clusters, this step require MCL being installed.
## 4) run sort_and_merge_sites_bed_cluster_mt.sh to identify the unique motifs in all clusters.

# The script run_process.sh runs the following steps
# step 5: compute the interaction score between each pair of Umotifs, this step require compute_interaction_score.py, compute_closest_tfbs_distance.py.
# step 6: uncommnet "run_get_keep_tfbs_for_cluster" to extract the TFBSs of the Umotifs and catenate the TFBSs into one using merge_keep_tfbs.py.

# The script run_crm.sh runs the following steps
# step 7: uncomment "run_merge_crm.sh" to catenate the adjacent TFBSs whose distance less than 300 bp, this step require script "run_merge_crm.sh" and bedtools.
# step 8: uncomment "run_compute_score_pair" to compute the score for both the CRM candidates (CRMCs) and Controls, this step require "compute_crm_score_v7_0_pair.py".
# step 9: uncomment "run_compute_p" to compute the empirical p value for CRMCs and Controls. This step require "compute_p_value_crm_v2.py". 
