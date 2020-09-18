#!/usr/bin/python
from __future__ import print_function
import sys
import networkx as nx
import random

def create_graph(network_name):
    G = nx.Graph()
    with open(network_name) as fin:
        for line in fin:
            from_node, to_node, weight = line.strip().split("\t")
            G.add_edge(from_node, to_node, weight=float(weight))

    return G


def randomize_network(network_name, G):
    random.seed(1234567)
    old_nodes_rank_list = list(G.nodes)
    new_nodes_rank_list = random.sample(old_nodes_rank_list, len(old_nodes_rank_list))
    mapping = dict(zip(old_nodes_rank_list, new_nodes_rank_list))
    
    R_G = nx.relabel_nodes(G, mapping)

    with open("mapping_nodes.txt", "w") as fout:
        for old, new in mapping.items():
            output = old+"\t"+new+"\n"
            fout.write(output)


    with open(network_name+".random", "w") as fout:
        for from_node, to_node, weight in R_G.edges.data():
            output = "{}\t{}\t{}\n".format(from_node, to_node, str(weight["weight"]))
            fout.write(output)


def main():
    network_name = sys.argv[1]
    G = create_graph(network_name)
    randomize_network(network_name,G)

if __name__=="__main__":
    main()
