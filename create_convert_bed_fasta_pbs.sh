#!/bin/bash
current_folder=$(pwd)
human_reference="/nobackup/zcsu_research/npy/cistrom/reference/hg38.fa"
mouse_reference="/nobackup/zcsu_research/npy/cistrom/reference/mm10.fa"

convert_bed_to_fasta_path="/nobackup/zcsu_research/npy/cistrom/convert_bed_fasta.sh"

#TF_human=$(#find . -type d -wholename "*TF_human*Sorted_Bed")
TF_human="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/"
for length in 1000 1500 3000
do
#TF_human="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_"${length}"/Sorted_Bed/"
TF_human="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_None_Folder/extend_to_"${length}"/Sorted_Bed/"
for folder in ${TF_human}
do
    cp ${convert_bed_to_fasta_path} ${folder}
    cd ${folder}
    pwd
    pbs="covert_bed_to_fasta.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash convert_bed_fasta.sh ${human_reference}" >> ${pbs}
    qsub ${pbs}

    cd ${current_folder}
done
done

#TF_mouse=$(#find . -type d -wholename "*TF_mouse*Sorted_Bed")
#TF_mouse="/nobackup/zcsu_research/npy/cistrom/TF_mouse/TF_mouse_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/"
#for folder in ${TF_mouse}
#do
#    cp ${convert_bed_to_fasta_path} ${folder}
#    cd ${folder}
#    pwd
#    pbs="covert_bed_to_fasta.pbs"
#    echo -e ${pbs_header} > ${pbs}
#    echo -e "bash convert_bed_fasta.sh ${mouse_reference}" >> ${pbs}
#    qsub ${pbs}
#    cd ${current_folder}
#done
