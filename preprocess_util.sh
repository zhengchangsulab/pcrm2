#!/bin/bash
function create_run_prosampler_pbs () {


    cp ${run_prosampler_path} .
    #cp ${prosampler_path} .
    #chmod 777 ProSampler
    #rm ProSampler
    if [[ ! -d Back_Ground_PBS ]];then
	mkdir Back_Ground_PBS
	mv small_patch*.pbs* Back_Ground_PBS
    fi

    pbses=$(ls *run_prosampler.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm -f *run_prosampler.pbs*
    fi
    
    #rm small_patch_*

    du *.fa.hard > file_name_index
    python split_small_patches.py file_name_index 700 small_patch
    
    small_patch_files=small_patch*
    for s in $small_patch_files
    do
	pbs=${s}.run_prosampler.pbs
	echo -e $pbs_header_cobra > $pbs
	echo -e "bash run_prosampler.sh $s" >> $pbs
	qsub $pbs
    done
}



function create_background_pbs () {

    cp ${create_generate_background_markov_path} .
    cp ${split_small_patches_path} .

    pbses=$(ls *.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm *.pbs
    fi


    rm small_patch_*

    du *.fa.hard > file_name_index
    python split_small_patches.py file_name_index 700 small_patch
    
    small_patch_files=small_patch*
    for s in $small_patch_files
    do
	pbs=${s}.pbs
	echo -e $pbs_header_cobra > $pbs
	echo -e "bash create_generate_background_markov.sh $s" >> $pbs
	qsub $pbs
    done
}


function sort_extend_peak () {

    pbs=sort_extend_bed.pbs
    echo -e $pbs_header > $pbs
    echo -e "bash sort_extend_bed.sh">> $pbs
    more $pbs
}


function create_hard_mask_pbs () {

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
    split -l 100 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_fasta_
    
    small_patch_files=small_patch_fasta*
    for s in $small_patch_files
    do
	pbs=${s}.pbs
	echo -e $pbs_header_cobra > $pbs
	echo -e "bash batch_hard_mask.sh $s" >> $pbs
	qsub $pbs
    done

}



function paser_site () {
    local fa_file=$1
    pro_out_folder=${fa_file}"_prosampler"
    if [[ ! -d $pro_out_folder ]];then
	mkdir $pro_out_folder
    fi
    
    mv ${fa_file}.prosampler* ${pro_out_folder}
    
    cp $paser_site_path $pro_out_folder
    cd $pro_out_folder
    python paser_site.py ${fa_file}.prosampler.site
    sites="motif_sites"
    if [[ ! -d $sites ]];then
    mkdir $sites
    fi
    mv *.motif ${sites}
    cd ../
}

function create_run_prosampler_pbs {
    for f in TF_human TF_mouse
    do
	file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_3000_sort/3000_fa_file"
	current_folder=$(pwd)

	cp split_small_patches.py $file_path
	cp run_prosampler.sh $file_path
	cd $file_path

	#rm -rf *prosampler.meme_fimo_out
	#rm -rf *_prosampler
	smalls=$(ls small*)
	if [[ ${#smalls[@]} -gt 0 ]];then
	    rm small*
	fi

	du *.hard.fa > file_name_index
	python split_small_patches.py file_name_index 700 small_patch_prosampler
	small_patch_files=small_patch_prosampler*
	for s in $small_patch_files
	do
	    pbs=${s}.pbs
	    echo -e $pbs_header > $pbs
	    echo -e "bash run_prosampler.sh $s" >> $pbs
	    qsub $pbs
	done
	cd $current_folder
    done
}


function create_rest_run_prosampler_pbs {
    for f in TF_human TF_mouse
    do
	file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_3000_sort/3000_fa_file"
	current_folder=$(pwd)

	cd $file_path
	fasta_file=*.fa
	for fa in $fasta_file
	do
	    if [[ ! -f ${fa}.prosampler.txt.meme ]];then

		#output=${fa}.prosampler.txt
		#pbs=${fa}.cobra.pbs
		#echo -e $pbs_header_cobra > ${pbs}
		#echo -e "time ProSampler -i ${fa} -b ${fa}.markov.bg -m 300 -o ${output} -t 1.65 -z 1.96" >> ${pbs}
		#qsub ${pbs}
		echo ${fa}
	    fi
	done
	cd $current_folder
    done
}




function create_change_prosampler_to_meme_header_pbs {
    for f in TF_human TF_mouse
    do
	file_path=${f}/${f}"_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_3000_sort/3000_fa_file"
	current_folder=$(pwd)
	cp run_prosampler_to_meme.sh $file_path
	cd $file_path
	
	pbs="change_prosampler_to_meme"
	echo -e $pbs_header > $pbs
	echo -e "bash run_prosampler_to_meme.sh" >> $pbs
	more $pbs
	cd $current_folder
    done
}

function check_un_run_prosampler {
    fa_files=*.fa
    for f in $fa_files
    do
	if [[ ! -f ${f}.prosampler.site ]];then
	    echo ${f} >> un_run_prosampler_file
	fi
    done
} 

function count_motif () {
    local fa_file=$1
    sites_folder=${fa_file}"_prosampler/motif_sites"
    ls $sites_folder|wc -l
}

function run_step_1 () {
    local fa_file=$1
    sites_folder=${fa_file}"_prosampler/motif_sites"
    cp $deprcm_path $sites_folder
    cd $sites_folder
    python DePRCM.py $fa_file
    cd ../../

}


function build_database_with_nonzero_motif_dataset {
    #mkdir dataset_with_less_equal_than_1_motif
    files=*.fa
    for f in $files
    do
	meme_out=${f}.prosampler.txt.meme
	motifs_list=($(more ${meme_out}|grep "MOTIF"|cut -d" " -f1))
	if [[ ${#motifs_list[@]} -le 1 ]];then
	    ls ${f}*
	    mv ${f}* dataset_with_less_equal_than_1_motif
	fi
    done
    
}

function build_database {
    mkdir dataset_with_greater_equal_than_1_motif
    files=*.fa
    for f in $files
    do
	mv ${f}* dataset_with_greater_equal_than_1_motif
    done
}

function move_small_patch_pbs {
    mkdir small_patch_pbs
    mv small* small_patch_pbs
}

function run_spic {
    pbs=run_spic.pbs
    echo -e ${pbs_header_cobra} > ${pbs}
    cmd="python run_spic.py"
    echo -e ${cmd} >> ${pbs}
    qsub ${pbs}
}


function run_spic_clique () {
    thred=$1
    pbs=run_spic_${thred}.pbs
    echo -e ${pbs_header} > ${pbs}
    cmd="python run_spic_clique.py $thred"
    echo -e ${cmd} >> ${pbs}
    qsub ${pbs}
}

function find_spic_edge () {
    thred=$1
    pbs=find_spic_edge_${thred}.pbs
    echo -e ${pbs_header} > ${pbs}
    cmd="python find_spic_edge.py $thred"
    echo -e ${cmd} >> ${pbs}
    qsub ${pbs}
}


function find_spic_edge_txt () {
    thred=$1
    pbs=find_spic_edge_${thred}.pbs
    echo -e ${pbs_header} > ${pbs}
    cmd="python find_spic_edge_txt.py $thred"
    echo -e ${cmd} >> ${pbs}
    qsub ${pbs}
}




function run_Sc {
    #rm small_patch_*.pbs*
    #rm small_patch_*

    #rm small_patch_dataset_index_001_index.txt.pbs  small_patch_dataset_index_001_index.txt.pbs.e1023601  small_patch_dataset_index_001_index.txt.pbs.o1023601  small_patch_dataset_index_001_index.txt_Sim_Score.txt

    split -l 200 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" dataset_index  small_patch_dataset_index_

    files=small_patch_dataset_index_*
    for f in $files
    do
	
	pbs=${f}.pbs
	#echo $pbs
	echo -e $pbs_header > $pbs
	echo -e "python compute_Sc.py $f" >> $pbs
	qsub $pbs
    done

}

function run_Sc_filter {
    files=small*Sim_Score.txt
    for f in $files
    do
	pbs=${f}.filter.pbs
	echo -e $pbs_header > ${pbs}
	echo -e "python filter_Sc.py ${f} 0.34" >> ${pbs}
	qsub ${pbs}
    done

}

function extract_motif_filter {
    pbs="run_extract_filtered_motif.pbs"
    echo -e $pbs_header > ${pbs}
    echo -e "python extract_filtered_motif.py" >> ${pbs}
    qsub ${pbs}
}
################################################################
# after 2018-12-14
function create_run_prosampler_pbs () {


    cp ${run_prosampler_path} .
    #cp ${prosampler_path} .
    #chmod 777 ProSampler
    #rm ProSampler
    if [[ ! -d Back_Ground_PBS ]];then
	mkdir Back_Ground_PBS
	mv small_patch*.pbs* Back_Ground_PBS
    fi

    pbses=$(ls *run_prosampler.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm -f *run_prosampler.pbs*
    fi
    
    #rm small_patch_*

    du *.fa.hard > file_name_index
    python split_small_patches.py file_name_index 700 small_patch
    
    small_patch_files=small_patch*
    for s in $small_patch_files
    do
	pbs=${s}.run_prosampler.pbs
	echo -e $pbs_header_cobra > $pbs
	echo -e "bash run_prosampler.sh $s" >> $pbs
	qsub $pbs
    done
}

function sort_extend_peak () {

    pbs=sort_extend_bed.pbs
    echo -e $pbs_header > $pbs
    echo -e "bash sort_extend_bed.sh">> $pbs
    qsub $pbs
}

function create_hard_mask_pbs () {

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
    split -l 100 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" file_name_index small_patch_fasta_
    
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

    pbses=$(ls *.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm *.pbs
    fi


    rm small_patch_*

    du *.fa.hard > file_name_index
    python split_small_patches.py file_name_index 700 small_patch
    
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
    if [[ ! -d Back_Ground_PBS ]];then
	mkdir Back_Ground_PBS
	mv small_patch*.pbs* Back_Ground_PBS
    fi

    pbses=$(ls *run_prosampler.pbs)
    if [[ ${#pbses[@]} -gt 0 ]];then
	rm -f *run_prosampler.pbs*
    fi
    
    #rm small_patch_*

    du *.fa.hard > file_name_index
    python split_small_patches.py file_name_index 700 small_patch
    
    small_patch_files=small_patch*
    for s in $small_patch_files
    do
	pbs=${s}.run_prosampler.pbs
	echo -e $pbs_header > $pbs
	echo -e "bash run_prosampler.sh $s" >> $pbs
	qsub $pbs
    done
}

function check_unrun_background(){
    files=*_sort.bed.fa.hard
    
    for f in ${files}
    do
	bg_file=${f}".markov.bg"
	if [[ ! -f ${bg_file} ]];then
	    pbs="run_create_background_"${f}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "markov -i ${f} -b ${f}.markov.bg" >> ${pbs}
	    more ${pbs}
	fi
    done

}


function count_tf_peak_number(){
    name=$1
    cp ${script_get_peaknumber} .
    pbs="run_count_peak_number.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_sequence_number.sh ${name}" >> ${pbs}
    qsub ${pbs}
}

function count_tf_dataset_peak_length(){
    name=$1
    cp ${script_get_peaklength} .
    pbs="run_count_peak_length.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_peak_length.sh ${name}" >> ${pbs}
    qsub ${pbs}

}


function count_tf_dataset_motif_number(){
    name=$1
    cp ${script_get_motifnumber} .
    pbs="run_count_motif_number.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bash count_motif_number.sh ${name}" >> ${pbs}
    qsub ${pbs}

}



function run_find_overlap_tf_pair(){

    cp ${script_get_overlap_tf_pair} .
    
    index=0
    files=*_sort.bed
    for f in ${files}
    do
	((index++))
	mode=$((${index} % 1500))
	if [[ ${mode} -eq 0 ]];then
	    sleep 10m
	fi
	pbs="run_overlap_"${f}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash compute_S0.sh ${f}" >> ${pbs}
	qsub ${pbs}
    done

}

function run_rest_find_overlap_tf_pair(){

    cp ${script_get_overlap_tf_pair} .
    
    index=0
    files=*_sort.bed
    for f in ${files}
    do
	overlap_file=${f}".overlap_with_others.txt"
	if [[ ! -f ${overlap_file} ]];then
	    ((index++))
	    mode=$((${index} % 1500))
	    if [[ ${mode} -eq 0 ]];then
		sleep 10m
	    fi
	    pbs="run_overlap_"${f}".r.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bash compute_S0.sh ${f}" >> ${pbs}
	    more ${pbs}
	fi
	
    done

}



function run_find_overlap_with_exon(){
    files=*_sort.bed

    index=0
    for f in ${files}
    do
	((index++))
	mode=$((${index} % 2000))
	if [[ ${mode} -eq 0 ]];then
	    echo "sleep 10m"
	fi
	
	#pbs="run_overlap_with_exon_"${f}".pbs"
	#echo -e ${pbs_header} > ${pbs}
	#echo -e "bedtools intersect -a ${f} -b ${bed_exon} > ${f}.overlap_with_exon" >> ${pbs}
	#qsub ${pbs}

	pbs="run_overlap_with_coding_exon_"${f}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bedtools intersect -a ${f} -b ${bed_coding_exon} > ${f}.overlap_with_coding_exon" >> ${pbs}
	qsub ${pbs}
    done


}

function run_find_rest_overlap_with_exon(){
    files=*_sort.bed

    index=0
    for f in ${files}
    do
	
	#overlap_with_exon_file=${f}".overlap_with_exon"

	#if [[ ! -f ${overlap_with_exon_file} ]];then
	#    ((index++))
	#    mode=$((${index} % 1500))
	#    if [[ ${mode} -eq 0 ]];then
	#     echo "sleep 20m"
	#    fi
	#    pbs="run_overlap_with_exon_"${f}".r.pbs"
	#    echo -e ${pbs_header} > ${pbs}
	#    echo -e "bedtools intersect -a ${f} -b ${bed_exon} > ${f}.overlap_with_exon" >> ${pbs}
	#    qsub ${pbs}
	#fi

	overlap_with_exon_file=${f}".overlap_with_coding_exon"

	if [[ ! -f ${overlap_with_exon_file} ]];then
	    ((index++))
	    mode=$((${index} % 1500))
	    if [[ ${mode} -eq 0 ]];then
		echo "sleep 20m"
	    fi
	    pbs="run_overlap_with_exon_"${f}".r.pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bedtools intersect -a ${f} -b ${bed_coding_exon} > ${f}.overlap_with_coding_exon" >> ${pbs}
	    qsub ${pbs}
	fi

    done
}


function move_none_pool_to_pool(){
    length=$1
    none_pool_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_None_Folder/extend_to_"${length}"/Sorted_Bed/"*"_sort.bed"

    cp ${none_pool_folder} .

}


function cat_merge_all(){
    length=$1
    pbs="cat_all_tf_dataset.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "cat *_sort.bed > TF_all_sort_motifs.${length}.bed.cat" >> ${pbs}
    echo -e "sort -k1,1 -k2,2n TF_all_sort_motifs.${length}.bed.cat > TF_all_sort_motifs.${length}.bed.cat.sort" >> ${pbs}
    qsub ${pbs}
}

function keep_3_field_sort(){
    length=$1
    pbs="keep_3_field_dataset.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "cut -f1,2,3 TF_all_sort_motifs.${length}.bed.cat.sort > TF_all_sort_motifs.${length}.bed.cat.sort.clean" >> ${pbs}
    qsub ${pbs}


}
function bedtools_merge_all(){
    length=$1
    pbs="merge_all_tf_dataset.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bedtools merge -i TF_all_sort_motifs.${length}.bed.cat.sort.clean > TF_all_sort_motifs.${length}.bed.cat.sort.clean.merge" >> ${pbs}
    qsub ${pbs}

}

function all_merge_overlap_with_coding_exon(){
    length=$1
    pbs="run_overlap_all_merge_overlap_with_exon.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bedtools intersect -a TF_all_sort_motifs.${length}.bed.cat.sort.clean.merge -b ${bed_coding_exon} > TF_all_sort_motifs.${length}.bed.cat.sort.clean.merge.overlap_with_coding_exon" >> ${pbs}
    qsub ${pbs}

}



function cat_merge_exon(){
    length=$1
    pbs="cat_all_tf_coding_exon_dataset.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "cat *overlap_with_coding_exon > TF_all_sort_motifs.${length}.bed.coding_exon.cat" >> ${pbs}
    echo -e "sort -k1,1 -k2,2n TF_all_sort_motifs.${length}.bed.coding_exon.cat > TF_all_sort_motifs.${length}.bed.coding_exon.cat.sort" >> ${pbs}
    qsub ${pbs}
}

function keep_3_field_sort_exon(){
    length=$1
    pbs="keep_3_field_dataset_exon.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "cut -f1,2,3 TF_all_sort_motifs.${length}.bed.coding_exon.cat.sort > TF_all_sort_motifs.${length}.bed.coding_exon.cat.sort.clean" >> ${pbs}
    qsub ${pbs}
}

function bedtools_merge_exon(){
    length=$1
    pbs="merge_all_tf_dataset_exon.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "bedtools merge -i TF_all_sort_motifs.${length}.bed.coding_exon.cat.sort.clean > TF_all_sort_motifs.${length}.bed.coding_exon.cat.sort.clean.merge" >> ${pbs}
    qsub ${pbs}
}



function run_paser_s0(){
    length=$1
    cp ${script_paser_overlap_s0} .
    peak_number_name="TF_human_filter_pool_peak_"${length}"_number.txt"
    pbs="run_paser_s0.pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python paser_S0.py ${peak_number_name}" >> ${pbs}
    qsub ${pbs}

}

function run_plot_s0(){
    length=$1
    cp ${script_plot_s0} .
    pbs="run_plot_s0.pbs"
    csv_name="TF_human_filter_pool_peak_"${length}"_number.matrix.csv"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python plot_S0.py ${csv_name}" >> ${pbs}
    qsub ${pbs}
    #python plot_S0.py ${csv_name}
}

#################################################################################
# script after 2019/1/25
#################################################################################
function convert_sites_bed_patch(){

    #rm small_patch_sites_files_*

    #ls *.sites > sites_file_name_index
    #split -l 500 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" sites_file_name_index small_patch_sites_files_
    
    cp ${script_paser_sites} .
    
    files=small_patch_sites_files_*.txt
    for f in ${files}
    do
	pbs="run_batch_"${f}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_site_to_bed.py ${f} 0" >> ${pbs}
	qsub ${pbs}
    done
}

function convert_site_bed_to_fa_patch(){
    cp ${script_convert_site_bed_to_fa} .

    small_patchs=small_patch_sites_files_*_index.txt
    for small_patch in ${small_patchs}
    do
	pbs="run_convert_site_bed_to_fa_patch_"${small_patch}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash convert_site_bed_to_fa.sh ${small_patch}" >> ${pbs}
	qsub ${pbs}
    done

    
}


function cat_site_bed_to_cluster(){
    cp ${script_cat_site_bed_cluster} .

    cluster_folders=cluster_*
    for cluster_folder in ${cluster_folders}
    do
	pbs="run_cat_site_bed_"${cluster_folder}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python cat_site_bed_cluster.py ${cluster_folder}" >> ${pbs}
	qsub ${pbs}
    done
}

function sort_merge_fasta_bg(){
    cluster_folders=cluster_*
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder}
	cp ${script_sort_and_merge_sites_bed_cluster} .
	cluster_bed=${cluster_folder}".bed"
	pbs="run_sort_and_merge_sites_bed_cluster_"${cluster_folder}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash sort_and_merge_sites_bed_cluster.sh ${cluster_bed}" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}


function sort_merge_fasta_bg_rest(){
    for cluster_folder_index in {1599..1947} #${cluster_folders}
    do
	cluster_folder="cluster_"${cluster_folder_index}

	cd ${cluster_folder}
	cp ${script_sort_and_merge_sites_bed_cluster} .
	cluster_bed=${cluster_folder}".bed"
	pbs="run_sort_and_merge_sites_bed_cluster_"${cluster_folder}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash sort_and_merge_sites_bed_cluster.sh ${cluster_bed}" >> ${pbs}
	qsub ${pbs}
	cd ../
    done
}


function run_prosampler_l0_cluster(){
    cluster_folders=cluster_*
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder}
	cluster_fa=${cluster_folder}".bed.sort.merge.fa"
	cluster_bg=${cluster_folder}".bed.sort.merge.fa.bg"

	size=(`du ${cluster_fa}`)
	
    
	min_mem=$((8388608/40))
	    
	if [[ ${size} -lt ${min_mem} ]];then
	    mem=8GB
	else
	    c=$(bc <<< "scale=1; ${size}/1048576*40")
	    mem=$((${c%.*}+1))"GB"
	fi

	pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
	
	pbs="run_prosampler_"${cluster_folder}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "ProSampler_l0 -i ${cluster_fa} -b ${cluster_bg} -o ${cluster_folder} -l 1" >> ${pbs}
	qsub ${pbs}

	cd ../
    done
}

function run_prosampler_l0_rest_cluster(){
    cluster_folders=cluster_*
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder}
	cluster_fa=${cluster_folder}".bed.sort.merge.fa"
	cluster_bg=${cluster_folder}".bed.sort.merge.fa.bg"

	
	if [[ ! -f ${cluster_folder}".meme" ]];then

	    size=(`du ${cluster_fa}`)
	
    
	    min_mem=$((8388608/40))
	    
	    if [[ ${size} -lt ${min_mem} ]];then
		mem=20GB
	    else
		c=$(bc <<< "scale=1; ${size}/1048576*40")
		mem=$((${c%.*}*2+1))"GB"
	    fi
	    
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=8:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
	    
	    pbs="re_run_prosampler_"${cluster_folder}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "ProSampler_l0 -i ${cluster_fa} -b ${cluster_bg} -o ${cluster_folder} -l 1" >> ${pbs}
	    qsub ${pbs}

	fi

	cd ../
    done
}
#################################################################################################################
# code after 2019/2/10
#################################################################################################################
function run_prosampler_l0_cluster(){
    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder}
	cluster_fa=${cluster_folder}".bed.sort.merge.fa"
	cluster_bg=${cluster_folder}".bed.sort.merge.fa.bg"

	size=(`du ${cluster_fa}`)
	
    
	min_mem=$((8388608/40))
	    
	if [[ ${size} -lt ${min_mem} ]];then
	    mem=8GB
	else
	    c=$(bc <<< "scale=1; ${size}/1048576*240")
	    mem=$((${c%.*}+1))"GB"
	fi

	pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
	
	pbs="run_prosampler_"${cluster_folder}"."${t_value}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "ProSampler_l0 -i ${cluster_fa} -b ${cluster_bg} -o ${cluster_folder}.${t_value} -l 0 -t ${t_value}" >> ${pbs}
	qsub ${pbs}

	cd ../
    done
}


function run_prosampler_l0_rest_cluster(){
    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder}
	cluster_fa=${cluster_folder}".bed.sort.merge.fa"
	cluster_bg=${cluster_folder}".bed.sort.merge.fa.bg"

	
	if [[ ! -f ${cluster_folder}"."${t_value}".meme" ]];then

	    size=(`du ${cluster_fa}`)
	
	    
	    min_mem=$((8388608/40))
	    
	    if [[ ${size} -lt ${min_mem} ]];then
		mem=20GB
	    else
		c=$(bc <<< "scale=1; ${size}/1048576*240")
		mem=$((${c%.*}+1))"GB"
	    fi
	    
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
	    
	    pbs="re_run_prosampler_"${cluster_folder}"."${t_value}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "ProSampler_l0 -i ${cluster_fa} -b ${cluster_bg} -o ${cluster_folder}.${t_value} -l 0 -t ${t_value}" >> ${pbs}
	    qsub ${pbs}

	fi

	cd ../
    done
}


function paser_meme_for_cluster(){

    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder} 


	cp ${script_paser_meme} .
	pbs="run_paser_meme_"${cluster_folder}"_"${t_value}".pbs"
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


	if [[ -f ${cluster_folder}"."${t_value}".meme" ]];then
	    if [[ ! -d ${paser_folder} ]];then
		
		pbs="re_run_paser_meme_"${cluster_folder}"_"${t_value}".pbs"
		echo -e ${pbs_header} > ${pbs}
		echo -e "python paser_prosampler_single.py ${cluster_folder}.${t_value}.meme" >> ${pbs}
		qsub ${pbs}
		
	    fi
	fi
	cd ../
    done
}

function plot_meme_logo(){
    cluster_folders=cluster_*
    t_value=$1
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder}

	cluster_motif_folder=${cluster_folder}"."${t_value}"_motif"

	if [[ -d ${cluster_motif_folder} ]];then
	    cd ${cluster_motif_folder}
	    
	    cp ${script_plot_logo} .
	    pbs="run_plot_meme_logo_"${cluster_folder}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "Rscript genLogo.R" >> ${pbs}
	    qsub ${pbs}
	    cd ../
	fi

	cd ../
    done
}

function convert_sites_bed_patch(){

    rm small_patch_sites_files_*

    ls *.sites > sites_file_name_index
    split -l 20 --numeric-suffixes=1 --suffix-length=3 --additional-suffix="_index.txt" sites_file_name_index small_patch_sites_files_
    
    cp ${script_paser_sites} .
    
    files=small_patch_sites_files_*.txt
    for f in ${files}
    do
	pbs="run_batch_"${f}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python paser_site_to_bed.py ${f} 0" >> ${pbs}
	qsub ${pbs}
    done
}


function sort_merge_sites_bed(){
    bed_files=*.sites.bed

    cp ${script_sort_and_merge_sites_bed} .
    for bed_file in ${bed_files}
    do
	pbs="run_merge_"${bed_file}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash sort_and_merge_sites_bed_cluster.sh ${bed_file}" >> ${pbs}
	qsub ${pbs}
    done
}


function sort_merge_sites_bed_rest(){
    bed_files=*.sites.bed
    for bed_file in ${bed_files}
    do
	sort=${bed_file}".sort"
	if [[ ! -f ${sort} ]];then

	    pbs="re_run_merge_"${bed_file}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "bash sort_and_merge_sites_bed_cluster.sh ${bed_file}" >> ${pbs}
	    qsub ${pbs}
	fi
    done
}

function remove_repeat_peak_cluster_merge(){

    cluster_folders=cluster_*
    for cluster_folder in ${cluster_folders}
    do
	cd ${cluster_folder} 

	cp ${script_remove_repeat_peak} .
	pbs="run_remove_repeat_peak_"${cluster_folder}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python filter_binding_sites.py ${cluster_folder}.bed.sort.merge " >> ${pbs}
	more ${pbs}
	cd ../
    done
}


function remove_repeat_peak_umotif_merge(){

    cp ${script_remove_repeat_peak} .

    cluster_merge_files=cluster_*_0.sites.bed.sort.merge

    for cluster_merge in ${cluster_merge_files}
    do
	pbs="run_remove_repeat_peak_umotif_"${cluster_merge}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python filter_binding_sites.py ${cluster_merge}" >> ${pbs}
	qsub ${pbs}
    done
}


function remove_repeat_peak_umotif_rest_merge(){

    cp ${script_remove_repeat_peak} .

    cluster_merge_files=cluster_*_0.sites.bed.sort.merge

    for cluster_merge in ${cluster_merge_files}
    do
	if [[ ! -f ${cluster_merge}".clean" ]];then
	    pbs="run_remove_repeat_peak_umotif_"${cluster_merge}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python filter_binding_sites.py ${cluster_merge}" >> ${pbs}
	    qsub ${pbs}

	fi
    done
}


function run_map_binding_site_to_origin(){

    t_value=$1

    cp ${script_map_binding_sites_to_original_peak} .
    cluster_clean_files=cluster*sites.bed.sort.merge.clean

    cluster_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_1500/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_30/UMOTIF_FOR_ALL_CLUSTER/CLUSTER_BED_MERGE/"

    ext_name="."${t_value}"_0.sites.bed.sort.merge.clean"

    for cluster_clean_file in ${cluster_clean_files}
    do

	
	cluster_name=${cluster_clean_file/${ext_name}/}
        cluster_path=${cluster_folder}${cluster_name}".bed.sort.merge.clean"

	size=(`du ${cluster_path}`)
	
	
	min_mem=$((8388608/40))
	
	if [[ ${size} -lt ${min_mem} ]];then
            mem=20GB
	else
            c=$(bc <<< "scale=1; ${size}/1048576*40")
	    mem=$((${c%.*}*3+20))"GB"
	fi
	
	pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
	pbs="run_convert_sites_to_origin_peak_"${cluster_clean_file}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python map_binding_sites_to_original_peak.py ${cluster_path} ${cluster_clean_file}" >> ${pbs}
	qsub ${pbs}
    done

}

function run_map_binding_site_to_rest_origin(){

    t_value=$1

    cp ${script_map_binding_sites_to_original_peak} .
    cluster_clean_files=cluster*sites.bed.sort.merge.clean

    cluster_folder="/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/Pool_Folder/extend_to_1500/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_30/UMOTIF_FOR_ALL_CLUSTER/CLUSTER_BED_MERGE/"

    ext_name="."${t_value}"_0.sites.bed.sort.merge.clean"

    for cluster_clean_file in ${cluster_clean_files}
    do

	if [[ ! -f ${cluster_clean_file}".origin" ]];then
	    cluster_name=${cluster_clean_file/${ext_name}/}
            cluster_path=${cluster_folder}${cluster_name}".bed.sort.merge.clean"
	    
	    size=(`du ${cluster_path}`)
	    
	    
	    min_mem=$((8388608/40))
	    
	    #if [[ ${size} -lt ${min_mem} ]];then
		#mem=20GB
	    #else
		#c=$(bc <<< "scale=1; ${size}/1048576*40")
		#mem=$((${c%.*}*3+20))"GB"
	    #fi
	    mem=256GB
	    
	    pbs_header="#!/bin/bash\n#PBS -l nodes=1:ppn=1,mem=${mem}\n#PBS -l walltime=20:00:00\n#PBS -q copperhead\n#PBS -l prologue=/users/pni1/torque/prologue.sh,epilogue=/users/pni1/torque/epilogue.sh\ncd \$PBS_O_WORKDIR"
	    pbs="run_convert_sites_to_origin_peak_"${cluster_clean_file}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python map_binding_sites_to_original_peak.py ${cluster_path} ${cluster_clean_file}" >> ${pbs}
	    qsub ${pbs}
	fi
    done

}

function run_filter_binding_sites_mt_2_peaks(){
    files=*.origin
    for f in ${files}
    do
	pbs="run_filter_origin_file_"${f}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "more ${f}|grep \",\" > ${f}.gt_2" >> ${pbs}
	qsub ${pbs}
    done
}


function run_filter_binding_sites_mt_2_rest_peaks(){
    files=*.origin
    for f in ${files}
    do
	if [[ ! -f ${f}".gt_2" ]];then
	    pbs="run_filter_origin_file_"${f}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "more ${f}|grep \",\" > ${f}.gt_2" >> ${pbs}
	    qsub ${pbs}
	fi
    done
}


function run_script_convert_gt_2_to_origin_peak_bed(){
    cp ${script_convert_gt_2_to_origin_peak_bed} .
    gt_2_files=*merge.clean.origin.gt_2
    for gt_2_file in ${gt_2_files}
    do
	pbs="run_script_convert_gt_2_to_origin_peak_bed_"${gt_2_file}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "python convert_gt_2_to_origin_peak_bed.py ${gt_2_file}" >> ${pbs}
	qsub ${pbs}
    done


}


function run_script_convert_gt_2_to_rest_origin_peak_bed(){
    cp ${script_convert_gt_2_to_origin_peak_bed} .
    gt_2_files=*merge.clean.origin.gt_2

    for gt_2_file in ${gt_2_files}
    do
	if [[ ! -f ${gt_2_file}".origin_bed" ]];then
	    pbs="re_run_script_convert_gt_2_to_origin_peak_bed_"${gt_2_file}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "python convert_gt_2_to_origin_peak_bed.py ${gt_2_file}" >> ${pbs}
	    more ${pbs}
	fi
    done
}

function run_un_finished_script_convert_gt_2_to_rest_origin_peak_bed(){
    o_files=run_script_convert_gt_2_to_origin_peak_bed_cluster_*_0.sites.bed.sort.merge.clean.origin.gt_2.pbs.o*
    for o_file in ${o_files}
    do
	exit_code=(`tail -2 ${o_file}|head -1`)
	code=${exit_code[2]}
	if [[ ${code} -eq -11 ]];then
	    pbs=${o_file%.*}
	    cmd=`tail -1 ${pbs}`
	    echo -e ${pbs_header} > ${pbs}
	    echo -e ${cmd} >> ${pbs}
	    qsub ${pbs}
	fi
    done
}
#==================================================================================================
# code after 2019/3/1
#==================================================================================================
function run_get_position(){
    origin_files=*merge.clean.origin.gt_2.origin_bed
    for origin_file in ${origin_files}
    do
	pbs="run_get_position_"${origin_file}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "cut -f1-3 ${origin_file} > ${origin_file}.pos" >> ${pbs}
	qsub ${pbs}

    done
}

function run_rest_get_position(){
    origin_files=*merge.clean.origin.gt_2.origin_bed
    for origin_file in ${origin_files}
    do
	if [[ ! -f ${origin_file}".pos" ]];then
	    pbs="run_get_position_"${origin_file}".pbs"
	    echo -e ${pbs_header} > ${pbs}
	    echo -e "cut -f1-3 ${origin_file} > ${origin_file}.pos" >> ${pbs}
	    qsub ${pbs}
	fi
    done
}

function create_position_file_folder(){

    folder="UMOTIF_BED_MERGE_CLEAN_ORIGIN_GT_2_ORIGIN_BED_POS_GT_2000"
    if [[ ! -d ${folder} ]];then
	mkdir ${folder}
    fi

    pos_files=*merge.clean.origin.gt_2.origin_bed.pos
    for pos_file in ${pos_files}
    do
	info=(`wc -l ${pos_file}`)
	if [[ ${info[0]} -gt 2000 ]];then
	    mv ${pos_file} ${folder}
	fi
    done
}



function run_script_umotif_origin_peak_overlap(){
    origin_files=*merge.clean.origin.gt_2.origin_bed.pos

    cp ${script_umotif_origin_peak_overlap} .
    for origin_file in ${origin_files}
    do
	pbs="run_umotif_origin_peak_overlap_"${origin_file}".pbs"
	echo -e ${pbs_header} > ${pbs}
	echo -e "bash umotif_origin_peak_overlap.sh ${origin_file}" >> ${pbs}
	more ${pbs}
    done

}

