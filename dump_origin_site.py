#!/usr/bin/python 
import pickle as pickle

#import json
import re
import ujson
import simplejson
import time
from collections import Counter
import sys

def paser_cluster_binding_site_map(cluster_origin):
    cluster_binding_site_origin_map = {}
    regex = re.compile(r"_[0-9]+:", re.IGNORECASE)

    origin_peak_dataset_list = []
    with open(cluster_origin) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            dataset = line_split[0].split("_")[0]
            origin_peak_dataset_list.append(dataset)

    origin_peak_dataset_dict = Counter(origin_peak_dataset_list)
    return origin_peak_dataset_dict 

def dump_pickle(cluster_name, dict_name):
    with open(cluster_name+".pickle", "wb") as handle:
        pickle.dump(dict_name, handle, protocol=pickle.HIGHEST_PROTOCOL)
        

def dump_json(cluster_name, dict_name):
    with open(cluster_name+".json", "wb") as fp:
        json.dump(dict_name, fp)


def dump_ujson(cluster_name, dict_name):
    with open(cluster_name+".ujson", "wb") as fp:
        ujson.dump(dict_name, fp)


def dump_simplejson(cluster_name, dict_name):
    with open(cluster_name+".simplejson", "wb") as fp:
        simplejson.dump(dict_name, fp)


def load_pickle(cluster_name):
    with open(cluster_name+".pickle", "rb") as handle:
        data = pickle.load(handle)
        

def load_json(cluster_name):
    with open(cluster_name+".json", "rb") as fp:
        data = json.load(fp)


def load_ujson(cluster_name):
    with open(cluster_name+".ujson", "rb") as fp:
        data = ujson.load(fp)


def load_simplejson(cluster_name):
    with open(cluster_name+".simplejson", "rb") as fp:
        data = simplejson.load(fp)

        

def main():
    cluster_name = sys.argv[1]
    #cluster_binding_site_origin_map, origin_peak_dataset_dict = paser_cluster_binding_site_map(cluster_name)
    print(sys.version)
    origin_peak_dataset_dict = paser_cluster_binding_site_map(cluster_name)

    #dump_simplejson(cluster_name, cluster_binding_site_origin_map)
    dump_simplejson(cluster_name + ".dataset_number", origin_peak_dataset_dict)
    
    #dump_pickle(cluster_name, cluster_binding_site_origin_map)
    #dump_ujson(cluster_name, cluster_binding_site_origin_map)
    
    """
    start = time.time()
    load_pickle(cluster_name)
    end = time.time()
    period = end - start
    print("pickle:", period)


    start = time.time()
    load_json(cluster_name)
    end = time.time()
    period = end - start
    print("json:", period)


    start = time.time()
    load_ujson(cluster_name)
    end = time.time()
    period = end - start
    print("ujson:", period)


    start = time.time()
    load_simplejson(cluster_name)
    end = time.time()
    period = end - start
    print("simplejson:", period)
    """

    
if __name__=="__main__":
    main()
