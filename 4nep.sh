#!/bin/bash

> ep_count.txt

while read line
do 
    line_count=$(wc -l < "/data/slurm/tmmap/chiapet_out/${line}/out/ep.bed")
    echo "${line}\t${line_count}" >> ep_count.txt
done < chiapet.txt

echo "chiapet finish"

while read line
do 
    line_count=$(wc -l < "/data/slurm/tmmap/hichip_out/${line}/ep.bed")
    echo "${line}\t${line_count}" >> ep_count.txt
done < hichip.txt

echo "hichip finish"
