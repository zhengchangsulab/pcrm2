#!/bin/bash
cutoff=$1

function split_small_patch(){

    mkdir -p SMALL_PATCH_CRMS/
    cd SMALL_PATCH_CRMS/

    all_crm_name="../ALL_CRMs_"${cutoff}
    split -l 5000 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed" ${all_crm_name} "small_patch_all_crms_"${cutoff}"_"
    
    all_crm_random_name="../ALL_CRMs_"${cutoff}".crm.bed.clean.fa"
    split -l 10000 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed.fa" ${all_crm_random_name} "small_patch_all_crms_"${cutoff}"_"

    cd ../
}


function split_small_random_patch(){

    mkdir -p SMALL_PATCH_CRMS_Random/
    cd SMALL_PATCH_CRMS_Random/

    all_crm_name="../ALL_CRMs_"${cutoff}
    split -l 5000 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed" ${all_crm_name} "small_patch_all_crms_"${cutoff}"_"

    all_crm_random_name="../ALL_CRMs_"${cutoff}".crm.bed.clean.fa.bg.fasta_peak_name"
    split -l 10000 --numeric-suffixes=1 --suffix-length=4 --additional-suffix="_index.bed.fa.bg.fasta_peak_name" ${all_crm_random_name} "small_patch_all_crms_"${cutoff}"_"

    cd ../
}

split_small_patch
split_small_random_patch


