#!/bin/bash
for inflat in 2.5 3 3.5 #1.4 2 4 6
do
    pbs="run_cluster_with_inflat_"${inflat}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "mcl ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.mci.bin -I ${inflat}" >> ${pbs}
    qsub ${pbs}
done
