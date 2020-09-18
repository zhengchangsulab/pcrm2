#!/bin/bash

files=Sc_Score_*.txt
for f in ${files}
do
    awk '$3 >= 0.6 {print $1"\n"$2}' ${f}|sort|uniq > ${f}".uniq"
done
