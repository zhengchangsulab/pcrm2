
function paser_meme_for_cluster(){

    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder} 


	cp ${script_paser_meme} .
	pbs="header_run_paser_meme_"${cluster_folder}"_"${t_value}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_prosampler_single.py ${cluster_folder}.${t_value}.meme" >> ${pbs}
	qsub ${pbs}

	cd ../
    done
}

function paser_meme_for_rest_cluster(){

    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder} 

	paser_folder=${cluster_folder}"."${t_value}"_motif"
	cp ${script_paser_meme} .
	umotif_0=${paser_folder}"/"${cluster_folder}"."${t_value}"_0.meme.meme"
	
	if [[ ! -f ${umotif_0} ]];then
	    pbs="header_re_run_paser_meme_"${cluster_folder}"_"${t_value}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python paser_prosampler_single.py ${cluster_folder}.${t_value}.meme" >> ${pbs}
	    qsub ${pbs}
	fi

	cd ../
    done
}

function sort_extend_peak () {

    pbs=sort_extend_bed.pbs
    echo -e $pbs_header > $pbs
    echo -e "bash sort_extend_bed.sh">> $pbs
    qsub $pbs
}

function convert_bed_to_fasta(){

    ref_genome=${hg38_fa}
    files=*_sort.bed

    if [[ -f run_convert_bed_to_fasta.sh ]];then
	rm -f run_convert_bed_to_fasta.sh
    fi
    
    for f in $files
    do
	
	echo -e "bedtools getfasta -fi $ref_genome -bed $f -fo ${f}.fa" >> run_convert_bed_to_fasta.sh
    done

    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.sh" run_convert_bed_to_fasta.sh small_patch_convert_to_fasta_

    files=small_patch_convert_to_fasta_*_index.sh
    for batch in ${files}
    do
	pbs="run_batch_convert_bed_"${batch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash ${batch}" >> ${pbs}
	more ${pbs}
    done
}

function submit_convert_fasta_batch(){
    files=small_patch_convert_to_fasta_*_index.sh
    for batch in ${files}
    do
	pbs="run_batch_convert_bed_"${batch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash ${batch}" >> ${pbs}
	qsub ${pbs}
    done

}


function check_un_finished_convert_fasta_batch(){
    files=small_patch_convert_to_fasta_*_index.sh
    for batch in ${files}
    do
	pbs="run_batch_convert_bed_"${batch}".pbs"
	error=(${pbs}.e*)

	if [[ ! -f ${error} ]];then
	    qsub ${pbs}
	fi

    done

}


function create_hard_mask_pbs () {


    cp ${hard_mask_path} .
    cp ${batch_hard_mask_path} .

    
    if [[ ! -d Hard_Fasta_File ]]
    then
	mkdir Hard_Fasta_File
    fi

    pbses=$(ls *.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm *.pbs
    fi

    rm small_patch_*

    ls *_sort.bed.fa > file_name_index
    split -l 20 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_fasta_
    
    small_patch_files=small_patch_fasta*
    for s in $small_patch_files
    do
	pbs=${s}.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash batch_hard_mask.sh $s" >> $pbs
	qsub $pbs
    done

}


function create_background_pbs () {

    cp ${create_generate_background_markov_path} .
    cp ${split_small_patches_path} .

    #rm *markov.bg
    pbses=$(ls *.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm *.pbs
    fi


    rm small_patch_*

    ls *.fa.hard > file_name_index
    #python split_small_patches.py file_name_index 700 small_patch
    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_fasta_
    
    small_patch_files=small_patch*
    for s in $small_patch_files
    do
	pbs=${s}.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash create_generate_background_markov.sh $s" >> $pbs
	qsub $pbs
    done
}


function create_run_prosampler_pbs () {


    cp ${run_prosampler_path} .
    #cp ${prosampler_path} .
    #chmod 777 ProSampler
    #rm ProSampler

    pbses=$(ls *run_prosampler.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm -f *run_prosampler.pbs*
    fi
    
    #rm small_patch_*

    #du *.fa.hard > file_name_index
    #python split_small_patches.py file_name_index 700 small_patch
    
    ls *.fa.hard > file_name_index
    #python split_small_patches.py file_name_index 700 small_patch
    split -l 10 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_prosampler_

    small_patch_files=small_patch_prosampler_*
    for s in $small_patch_files
    do
	pbs=${s}.run_prosampler.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash run_prosampler.sh $s" >> $pbs
	qsub $pbs
    done
}


function check_un_run_prosampler {
    #rm run_single_*_prosampler.pbs

    
    fa_files=*.fa.hard

    for f in $fa_files
    do
	if [[ ! -f ${f}.prosampler.txt.site ]];then

	    output=${f}.prosampler.txt

	    pbs="run_single_"${f}"_prosampler.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "time ProSampler -i ${f} -b ${f}.markov.bg -o ${output}" >> ${pbs}
	    qsub ${pbs}

	fi
    done
}
