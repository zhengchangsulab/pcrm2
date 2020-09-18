#!/bin/bash
pbs_header_mt='#!/bin/bash\n#PBS -l nodes=1:ppn=16\n#PBS -l walltime=100:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd $PBS_O_WORKDIR'

for inflat in 1.1 1.2 1.3 #1.5 1.6 1.7 1.8 1.9 #2.6 2.7 2.8 2.9 #2.1 2.2 2.3 2.4 #1 1.4 2 2.5 #3.5 #3 4 6 #2.5 3 3.5 #1.4 2 4 6
do
    pbs="run_cluster_with_inflat_mt"${inflat}".pbs"
    output="out.ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.mci.bin.multi_threads.I"${inflat}

    echo -e ${pbs_header_mt} > ${pbs}
    echo -e "mcl ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.mci.bin -I ${inflat} -t 16 -o ${output}" >> ${pbs}
    qsub ${pbs}
done
