from __future__ import print_function
import matplotlib
matplotlib.use('Agg')
#get_ipython().magic(u'matplotlib inline')
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import numpy as np
import sys
import seaborn as sns


def paser_score(name):
    score_list = []
    with open(name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            score_list.append(float(line_split[2]))
            
    return np.array(score_list)

            
name = sys.argv[1]            
s = sys.argv[2]
score = paser_score(name)

fig, ax = plt.subplots(1,1, figsize=(8,8))
#ax.hist(score, bins=500)
sns.kdeplot(score, bw=0.02)
#ax.axvline(x=0.1)
#plt.show()
plt.savefig("{}-{}.png".format(name,s), dpi=300)
