#!/usr/bin/python
from __future__ import print_function
import sys
    

def get_cluster_pair(cluster_index, cutoff):

   pair_list = []

   with open("Umotif_Interaction_Score.txt") as fin:
      for line in fin:
         line_split = line.strip().split("\t")
         score = float(line_split[2])
         cluster_pair = line_split[:2]

         if score >= float(cutoff):
            if cluster_index in cluster_pair:
               cluster_pair.pop(cluster_pair.index(cluster_index))
               
               pair_list.append(cluster_pair[0])
   return pair_list
    
def get_cluster_pair_tfbs(cluster_index, pair_list):


    tfbs_cluster = set()

    for pair in pair_list:
       tfbs_path_name = "{}/{}-{}.overlap.dist.c.tfbs".format(cluster_index, cluster_index, pair)
       print(tfbs_path_name)
       with open(tfbs_path_name) as fin:
          for line in fin:
             chrom, _, _, tfbs  = line.strip().split("\t")
             tfbs_info = "{}|{}".format(chrom, tfbs)
             tfbs_cluster.add(tfbs_info)
             

    keep_tfbs_cluster_name = "{}.KEEP_TFBS".format(cluster_index)
    with open(keep_tfbs_cluster_name, "w") as fout:
        for tfbs in tfbs_cluster:
            tfbs_split = tfbs.split("|")
            chrom = tfbs_split[0]
            tfbs = tfbs_split[2]
            start, end = tfbs.split(":")
            cluster_index = tfbs_split[1]

            output = "{}\t{}\t{}\t{}|{}\n".format(chrom, start, end, cluster_index, tfbs)
            fout.write(output)


                
def main():
    cluster_index = sys.argv[1]
    cutoff = sys.argv[2]
    cluster_pair_list = get_cluster_pair(cluster_index, cutoff)
    get_cluster_pair_tfbs(cluster_index, cluster_pair_list)

if __name__=="__main__":
    main()
