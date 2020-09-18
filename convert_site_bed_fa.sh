#!/bin/bash

ref=$1
site_beds=*.bed
for bed in ${site_beds}
do
    bedtools getfasta -fi ${ref} -bed ${bed} -fo ${bed}.fa
    motif_name=${bed/.sites.bed/}
    sed -i "s/>/>${motif_name}:/" ${bed}.fa
done 
