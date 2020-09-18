#!/usr/bin/env python
# coding: utf-8


from __future__ import print_function
import matplotlib
matplotlib.use('Agg')
#get_ipython().magic(u'matplotlib inline')
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import numpy as np
import sys
import seaborn as sns

def setting_axes(ax):
    for axis in ['top', 'bottom', 'left', 'right']:
        ax.spines[axis].set_linewidth(4)
        
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    
    #ax.set_xlim(-9, 9)
    #ax.set_ylim(0, 0.3)
    
    #ax.set_xticks(np.arange(-9.0, 9.0, 2))
    #ax.set_yticks([0, 0.1, 0.2, 0.3])
    #ax.xaxis.set_tick_params(labelsize=30)
    #ax.yaxis.set_tick_params(labelsize=30)
    ax.set_xticklabels(ax.get_xticks(), fontsize=30, rotation=0)
    #ax.set_yticklabels(ax.get_yticks(), fontsize=30, rotation=40)
    #ax.set_yticklabels([0., 0.05, 0.1,  0.15, 0.2,  0.25, 0.3], fontsize=30, rotation=40)

    #ax.set_yticklabels([round(y, 2) for y in ax.get_yticks()], fontsize=30, rotation=40)
    #ax.set_yticklabels([0., 0.1, 0.2, 0.3], fontsize=30, rotation=0)
    ax.set_yticklabels(ax.get_yticks(), fontsize=30, rotation=0)
    
    #ax.yaxis.set_major_formatter(StrMethodFormatter('{x:,.2f}'))
    #ax.yaxis.set_major_formatter(StrMethodFormatter('{x:,.4f}'))
    
    xfmt = ScalarFormatter(useMathText=True)
    xfmt.set_powerlimits((-1,2))
    ax.yaxis.set_major_formatter(xfmt)
    ax.xaxis.set_major_formatter(xfmt)
    
    ax.yaxis.get_offset_text().set_fontsize(30)
    ax.xaxis.get_offset_text().set_fontsize(30)
    
    ax.set_xlabel(r"$S_{c}$ score", fontsize=35)
    ax.set_ylabel("Density", fontsize=35)

    ax.tick_params(axis='both', length=6, width=3)
    
    ax.locator_params(axis='x', nbins=7)
    ax.locator_params(axis='y', nbins=7)
    ax.xaxis.set_label_coords(0.5, -0.15)
    

    ax.legend(fontsize=20, loc='best', frameon=False, borderaxespad=0) 



def paser_sc(file_name):
    sc_list = []
    with open(file_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            sc = float(line_split[2])
            sc_list.append(sc)
    sc_score = np.asarray(sc_list)

    return sc_score

sc_name = sys.argv[1]
bw_value = sys.argv[2]
sc_score = paser_sc(sc_name)


fig, ax = plt.subplots(1,1, figsize=(8,6), dpi=300, facecolor='white')
ax = sns.kdeplot(sc_score, bw=float(bw_value), color='k', clip=(-30, 50), ax=ax, linewidth=3)
#ax.hist(sc_score, bins=100, color='g', edgecolor='k', histtype='bar')
#ax = sns.kdeplot(sc_score, bw=0.5, color='r', clip=(-30, 50), ax=ax, cumulative=True, linewidth=3, label='CDF')
ax.axvline(x=0.7, color='r', linestyle='dashed', linewidth=2)

#ax = sns.kdeplot(sc_score, bw=0.3, color='r', clip=(0, 5000), ax=ax, cumulative=True, label='CDF')
setting_axes(ax)
plt.tight_layout()
plt.savefig(sc_name+"."+bw_value+".svg", dpi=300)
#plt.savefig(sc_name+".hist."+".svg", dpi=300)

