#!/bin/bash

inflat=3
output="out.ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.mci.bin.multi_threads.I"${inflat}

echo -e ${pbs_header_mt} > ${pbs}
echo -e "mcl ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.mci.bin -I ${inflat} -t 16 -o ${output}" >> ${pbs}
