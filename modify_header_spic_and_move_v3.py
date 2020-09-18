#!/usr/bin/python
from __future__ import print_function
import sys
import shutil
import glob
import os
import stat

def modify_spic(spic_file, folder_name):
    output_name=spic_file.replace(".motif", ".spic").replace("_sort_peaks", "")
    out_spic_folder_name="{}_spic".format(output_name.split("_")[0])

    output_path="/nobackup/zcsu_research/NPY/{}_keep_motifs/SPIC/{}/".format(folder_name, out_spic_folder_name)
    os.makedirs(output_path, exist_ok=True)
    #os.chmod(output_path, stat.S_IRUSR |stat.S_IWUSR | stat.S_IXUSR | stat.S_IRGRP | stat.S_IWGRP | stat.S_IXGRP)
    os.chmod(output_path, 0o770)
    
    
    output_file_name = "{}{}".format(output_path, output_name)

    with open(output_file_name, "w") as fout:
        with open(spic_file) as fin:
            lines = fin.readlines()
            try:
                header = "_".join(lines[0].replace("_sort_peaks", "").split(".")[:2])+"\n"
                lines[0] = header
                for line in lines:
                    fout.write(line)
                os.chmod(output_file_name, 0o777)

            except:
                print(spic_file)
        
def paser_small_motif(small_patch_name):
    motif_list = []
    with open(small_patch_name) as fin:
        for line in fin:
            motif = "{}.motif".format(line.strip())
            motif_list.append(motif)

    return motif_list

def main():
    folder_name = sys.argv[1]
    #small_patch_name = sys.argv[2]
    
    #motif_list = paser_small_motif(small_patch_name)
    motif_list = glob.glob("*.motif")
    #files=glob.glob("*.motif")
    for spic_file in motif_list:
        modify_spic(spic_file, folder_name)


if __name__=="__main__":
    main()
