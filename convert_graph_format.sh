#!/bin/bash
#time mcl cathat --abc -o out_base

###########################
#mcxload -abc cathat --stream-mirror -write-tab data.tab -o cathat.mci
#time mcl cathat.mci
#mcxdump -icl out.cathat.mci.I20 -tabr data.tab -o dump.out.cathat.mci.I20

###########################
#mcxload -abc cathat --stream-mirror --write-binary -write-tab data.bin.tab -o cathat.mci.bin
#time mcl cathat.mci.bin
#mcxdump -icl out.cathat.mci.bin.I20 -tabr data.bin.tab -o dump.out.cathat.bin.mci.I20

function convert_to_bin(){
    spic="ALL_KEEP_MOTIF_PAIR_SPIC_GT_THAN_0.8.txt"
    mcxload -abc ${spic} --stream-mirror --write-binary -write-tab ${spic}".tab" -o ${spic}".mci.bin"
}

convert_to_bin
