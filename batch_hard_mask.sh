#!/bin/bash
pn=$1

while IFS= read -r line
do
    python hard_mask.py $line
    mv ${line}".hard" Hard_Fasta_File
done<"$pn"


