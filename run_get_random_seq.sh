#!/bin/bash
crm=$1
ref_fa=$2
cut -f1,2,3 ${crm} > ${crm}".crm.bed.clean"
bedtools getfasta -fi ${ref_fa} -bed ${crm}".crm.bed.clean" -fo ${crm}".crm.bed.clean.fa"
markov -i ${crm}".crm.bed.clean.fa" -b ${crm}".crm.bed.clean.fa.bg"
python change_peak_name_background.py ${crm}".crm.bed.clean.fa" ${crm}".crm.bed.clean.fa.bg"
