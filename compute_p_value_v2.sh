#!/bin/bash
random_score=$1
total_number=(`wc -l ${random_score}`)

p_value_name=${random_score}".p_value"
rm ${p_value_name}

for i in $(seq 0 1 1500)
do
    number_t=(`awk -v t=${i} '$1>t' ${random_score}|wc -l`)
    p_value=(`echo "scale=20; ${number_t}/${total_number}"|bc`)

    echo -e ${i}"\t""0"${p_value} >> ${p_value_name}
done
