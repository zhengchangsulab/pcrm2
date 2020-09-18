function move_meme_site_spic(){
    mkdir MOTIFS

    mv *.meme MOTIFS
    mv *.site MOTIFS
    mv *.spic MOTIFS

}


function run_paser_prosampler(){
    cp ${script_paser_prosampler_path} .

    index=0
    meme_files=*.meme

    for meme in ${meme_files}
    do
	pbs="run_paser_"${meme}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler_single.py ${meme}" >> ${pbs}
	echo ${pbs}

	((index ++))

	flag=$((index % 1000))

	if [[ ${flag} -eq 0 ]];then
	    echo "sleep 10m"

	fi
    done
}


function run_paser_prosampler_batch(){

    cp ${script_paser_prosampler_path} .
    
    ls *.meme > file_name_index
    split -l 100 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_meme_

    small_patch_files=small_patch_meme*

    for s in ${small_patch_files}
    do
	pbs="run_paser_"${s}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler.py ${s}" >> ${pbs}
	qsub ${pbs}
    done
}



function run_compute_sc_score(){
    cp ${compute_sc_score_path} .
    meme_files=*fa.hard.prosampler.txt.meme

    index=0

    for meme in ${meme_files}
    do
	tf_index=${meme%%_*}
	pbs="run_compute_sc_"${tf_index}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python compute_Sc_v0.3.py ${tf_index}" >> ${pbs}
	qsub ${pbs}

	((index ++))

	flag=$((index % 1000))

	if [[ ${flag} -eq 0 ]];then
	    sleep 5m

	fi
    done
}

function check_run_compute_sc_score(){
    cp ${compute_sc_score_path} .
    meme_files=*fa.hard.prosampler.txt.meme


    for meme in ${meme_files}
    do
	tf_index=${meme%%_*}
	Sc_score="Sc_Score_"${tf_index}".u.txt"

	pbs="run_compute_sc_"${tf_index}".pbs"
	if [[ ! -f ${Sc_score} ]];then
	    qsub ${pbs}

	fi
    done
}


function run_plot_sc_dist(){

    cp ${plot_dist_path} .
    #cat Sc_Score_*.u.txt > Sc_score_human_1000.u.total.txt

    pbs="run_plot_sc_hist.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_Sc_dist.py Sc_score_human_1000.u.total.txt" >> ${pbs}
    qsub ${pbs}
}

function run_count_motif_number(){
    cp ${count_motifs_script} .

    pbs="run_counts_motif.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_motifs.sh" >> ${pbs}
    qsub ${pbs}
}

function run_build_keep_motif_dataset(){
    cp ${build_keep_motif_dataset_script} .
    pbs="run_build_keep_motif_script.u.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash build_keep_motif_dataset.sh Sc_score_human_1000.u.total_0.7.keep_motif.txt" >> ${pbs}
    qsub ${pbs}
}

