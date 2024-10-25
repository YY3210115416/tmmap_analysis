#!/bin/bash

# hichiop
while IFS=$'\t' read -r line; do 
    echo "Processing GSM: $line"
    bedtools intersect -wo -b /data/slurm/tmmap/GWASdataset/snps.bed -a <(awk 'BEGIN{FS=OFS="\t"}{print $10, $11, $12, $0}' /data/slurm/tmmap/hichip_out/${line}/ep.bed) | \
    awk 'BEGIN{FS=OFS="\t"} {print $0, "promoter"}' | \
    sort -u | \
    awk 'BEGIN{FS=OFS="\t"} {print $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $20, $22}' > /data/slurm/tmmap/hichip_out/${line}/epgwas.bed

    bedtools intersect -wo -b /data/slurm/tmmap/GWASdataset/snps.bed -a <(awk 'BEGIN{FS=OFS="\t"}{print $4, $5, $6, $0}' /data/slurm/tmmap/hichip_out/${line}/ep.bed) | \
    awk 'BEGIN{FS=OFS="\t"} {print $0, "enhancer"}' | \
    sort -u | \
    awk 'BEGIN{FS=OFS="\t"} {print $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $20, $22}' >> /data/slurm/tmmap/hichip_out/${line}/epgwas.bed

done < /data/slurm/tmmap/hichip.txt

# chiapet
while IFS=$'\t' read -r line; do 
    echo "Processing GSM: $line"
    bedtools intersect -wo -b /data/slurm/tmmap/GWASdataset/snps.bed -a <(awk 'BEGIN{FS=OFS="\t"}{print $10, $11, $12, $0}' /data/slurm/tmmap/chiapet_out/${line}/out/ep.bed) | \
    awk 'BEGIN{FS=OFS="\t"} {print $0, "promoter"}' | \
    sort -u | \
    awk 'BEGIN{FS=OFS="\t"} {print $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $20, $22}' > /data/slurm/tmmap/chiapet_out/${line}/out/epgwas.bed

    bedtools intersect -wo -b /data/slurm/tmmap/GWASdataset/snps.bed -a <(awk 'BEGIN{FS=OFS="\t"}{print $4, $5, $6, $0}' /data/slurm/tmmap/chiapet_out/${line}/out/ep.bed) | \
    awk 'BEGIN{FS=OFS="\t"} {print $0, "enhancer"}' | \
    sort -u | \
    awk 'BEGIN{FS=OFS="\t"} {print $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $20, $22}' >> /data/slurm/tmmap/chiapet_out/${line}/out/epgwas.bed

done < /data/slurm/tmmap/chiapet.txt
