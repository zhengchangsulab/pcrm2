#!/bin/bash
files=*.origin
for f in ${files}
do
    pbs="run_filter_origin_file_"${f}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "more ${f}|grep \",\" > ${f}.gt_2" >> ${pbs}
    qsub ${pbs}
done
