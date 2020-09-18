#!/usr/bin/python
import glob

def main():
    origin_peak_number_files=glob.glob("cluster_*sites.bed.origin.origin_peak.origin_peak_number")


    for peak_number in origin_peak_number_files:

        cluster_name = peak_number.replace(".30.8.8_0.sites.bed.origin.origin_peak.origin_peak_number", "")
        with open(peak_number) as fin:
            for line in fin:
                peak_number_value = int(line.strip())


        origin_cluster_root_path = "/nobackup/zcsu_research/npy/cistrom/TF_human/TF_human_20_20_20_350_350_filter/filter_score_chr/filter_score_chr_unsort/extend_to_1000/Sorted_Bed/Fasta_File/Hard_Fasta_File/MOTIFS/MOTIF_U_PSM_GT_0.7_SPIC_FOLDER/Cluster_Inflation_1.1"

        origin_cluster_name = "{}/{}/{}".format(origin_cluster_root_path, cluster_name, cluster_name+".bed.sort.origin_peak_number")
        with open(origin_cluster_name) as fin:
            for line in fin:
                origin_peak_number_value = int(line.strip())


        ratio = "{0:.4f}".format(peak_number_value/float(origin_peak_number_value))

        output = "{}\t{}".format(cluster_name, ratio)
        
        print(output)


if __name__=="__main__":
    main()
