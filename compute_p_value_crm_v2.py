#!/bin/python
import numpy as np
import sys

def paser_random_score(random_score_name):
    random_score_list = []
    with open(random_score_name) as fin:
        for line in fin:
            line_split = line.strip().split("\t")
            random_score_list.append(float(line_split[4]))


    return np.array(random_score_list)


def main():
    crm_name = sys.argv[1]
    random_score_name = sys.argv[2]
    random_score = paser_random_score(random_score_name)

    total_number = random_score.shape[0]

    with open("{}.p_value".format(crm_name), "w") as fout:
        with open(crm_name) as fin:
            for line in fin:
                line_split = line.strip().split("\t")
                score = float(line_split[4])
                random_score_lt = (random_score > score).sum()
                p_value = float(random_score_lt/total_number)
                output = "{}\t{}\n".format(line.strip(), str(p_value))

                fout.write(output)
    



if __name__=="__main__":
    main()
