#!/usr/bin/python
from __future__ import print_function
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd
import sys

def main():
    csv_name = sys.argv[1]
    df = pd.read_csv(csv_name, header=0, index_col=0)
    g = sns.clustermap(data=df.values)
    g.savefig(csv_name+".clsuter.png")

if __name__=="__main__":
    main()
