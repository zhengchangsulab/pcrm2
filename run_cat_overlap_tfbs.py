#!/usr/bin/python 
from __future__ import print_function

def main():

    with open("Merge_CRM_Norm_ALL/TOTAL_KEEP_BINDING_SITES_Norm_ALL.bed", "w") as fout:
        
        with open("Umotif_Interaction_Score_gt_0.2.txt") as fin:
            for line in fin:
                line_split = line.strip().split("\t")
                cluster_1 = line_split[0]
                cluster_2 = line_split[1]
                
                overlap_name_1 = "{}/{}-{}.overlap.dist".format(cluster_1, cluster_1, cluster_2)
                overlap_name_2 = "{}/{}-{}.overlap.dist".format(cluster_2, cluster_2, cluster_1)
                
                cluster_1_index = cluster_1.replace("cluster_", "")
                with open(overlap_name_1) as fin:
                    for line in fin:
                        line_split = line.strip().split("\t")
                        dataset = line_split[0].split("_")[0]
                        chrom = line_split[0].split("_")[1]
                        tfbs_list = line_split[3].split(",")
                        for tfbs in tfbs_list:
                            start, end = tfbs.split(":")
                            output = "{}\t{}\t{}\t{}|{}|{}:{}-{}\n".format(chrom, start, end, cluster_1_index, dataset, chrom, start, end)
                            fout.write(output)


                cluster_2_index = cluster_2.replace("cluster_", "")
                with open(overlap_name_2) as fin:
                    for line in fin:
                        line_split = line.strip().split("\t")
                        dataset = line_split[0].split("_")[0]
                        chrom = line_split[0].split("_")[1]
                        tfbs_list = line_split[3].split(",")
                        for tfbs in tfbs_list:
                            start, end = tfbs.split(":")
                            output = "{}\t{}\t{}\t{}|{}|{}:{}-{}\n".format(chrom, start, end, cluster_2_index, dataset, chrom, start, end)
                            fout.write(output)
                            



if __name__=="__main__":
    main()
