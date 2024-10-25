#!/bin/bash

output_file="allloop.txt"

> "$output_file"

while IFS= read -r line; do
    awk -v id="$line" '{print id "\t" $0}' "/data/slurm/tmmap/chiapet_out/${line}/out/epqtl.txt"
done < chiapet.txt >> "$output_file"

echo "chiapet finish"

while IFS= read -r line; do
    awk -v id="$line" '{print id "\t" $0}' "/data/slurm/tmmap/hichip_out/${line}/epqtl.txt"
done < hichip.txt >> "$output_file"

echo "hichip finish"

#sort -u "$output_file" -o "$output_file"

echo "Duplicates removed"
