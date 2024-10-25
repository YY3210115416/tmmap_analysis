#!/bin/bash

enhancer_file="/data/slurm/tmmap/enhancer.bed"
#promoter_file="/data/slurm/tmmap/promoter.bed"

> "$enhancer_file"
#> "$promoter_file"

while read -r gsm_id; do
    epgwas_path="/data/slurm/tmmap/hichip_out/${gsm_id}/epgwas.bed"
    
    if [ -f "$epgwas_path" ]; then
        awk 'BEGIN{OFS="\t"} {print $4, $5, $6}' "$epgwas_path" >> "$enhancer_file"
        #awk 'BEGIN{OFS="\t"} {print $1, $5, $6}' "$epgwas_path" >> "$promoter_file"
    else
        echo "no $epgwas_path " >&2
    fi
done < /data/slurm/tmmap/hichip.txt

while read -r gsm_id; do
    epgwas_path="/data/slurm/tmmap/chiapet_out/${gsm_id}/out/epgwas.bed"
    
    if [ -f "$epgwas_path" ]; then
        awk 'BEGIN{OFS="\t"} {print $4, $5, $6}' "$epgwas_path" >> "$enhancer_file"
        #awk 'BEGIN{OFS="\t"} {print $4, $5, $6}' "$epgwas_path" >> "$promoter_file"
    else
        echo "no $epgwas_path " >&2
    fi
done < /data/slurm/tmmap/chiapet.txt

sort /data/slurm/tmmap/enhancer.bed | uniq > /data/slurm/tmmap/enhancer_unique.bed && mv /data/slurm/tmmap/enhancer_unique.bed /data/slurm/tmmap/enhancer.bed
#sort /data/slurm/tmmap/promoter.bed | uniq > /data/slurm/tmmap/promoter_unique.bed && mv /data/slurm/tmmap/promoter_unique.bed /data/slurm/tmmap/promoter.bed