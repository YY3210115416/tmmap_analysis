#!/bin/bash

input_file="epgwas.bed"
output_file="epgwas1.bed"

# Process hichip data
while read line; 
do  
    echo "Processing GSM: $line"
    path="/data/slurm/tmmap/hichip_out/${line}/"
    awk -v OFS='\t' '($6 - $5) < 10000' "${path}${input_file}" > "${path}${output_file}"
done < /data/slurm/tmmap/hichip.txt

# Process chiapet data
while read line; 
do  
    echo "Processing GSM: $line"
    path="/data/slurm/tmmap/chiapet_out/${line}/out/"
    awk -v OFS='\t' '($6 - $5) < 10000' "${path}${input_file}" > "${path}${output_file}"
done < /data/slurm/tmmap/chiapet.txt
