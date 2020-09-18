#!/bin/bash
small_batch=$1
mkdir -p Sorted

while IFS= read -r line
do
    sort -k1,1 -k2,2n --parallel=2 ${line} > "Sorted/"${line}".sort"

done<${small_batch}
