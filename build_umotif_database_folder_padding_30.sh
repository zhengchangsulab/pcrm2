#!/bin/bash
mkdir UMOTIF_FOR_ALL_CLUSTER_8_30/
mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_LOGO
mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME
mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME_BIO
mkdir -p UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SPIC


cp cluster_*/cluster_*.30.8.8_motif/cluster_*.30.8.8_0.meme UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_LOGO
cp cluster_*/cluster_*.30.8.8_motif/cluster_*.30.8.8_0.meme.with_header UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME
cp cluster_*/cluster_*.30.8.8_motif/cluster_*.30.8.8_0.sites UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SITES
cp cluster_*/cluster_*.30.8.8_motif/cluster_*.30.8.8_0.*bio UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_MEME_BIO
cp cluster_*/cluster_*.30.8.8_motif/cluster_*.30.8.8_0.*motif UMOTIF_FOR_ALL_CLUSTER_8_30/UMOTIF_SPIC
