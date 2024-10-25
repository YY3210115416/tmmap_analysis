#!/bin/bash

> epgwas_count.txt

while read line
do 
    # Count unique combinations of the first six columns
    line_count=$(awk '!seen[$0]++ {count++} END {print count}' "/data/slurm/tmmap/chiapet_out/${line}/out/epgwas1.bed")
    echo "${line}\t$line_count" >> epgwas_count.txt
done < chiapet.txt

echo "chiapet finish"

while read line
do 
    # Count unique combinations of the first six columns
    line_count=$(awk '!seen[$0]++ {count++} END {print count}' "/data/slurm/tmmap/hichip_out/${line}/epgwas1.bed")
    echo "${line}\t$line_count" >> epgwas_count.txt
done < hichip.txt

echo "hichip finish"



