#!/bin/bash

for count in 200 300 400 500 600 700 800 1000 1200
do
    pbs="run_count_"${count}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python count_region_binding_site.py ALL_150.CRM ${count}" >> ${pbs}
    qsub ${pbs}
done
