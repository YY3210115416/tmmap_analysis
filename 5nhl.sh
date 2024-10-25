#!/bin/bash

> epgwas_high_low_count.txt

# Function to count unique combinations of 'high' and 'low' for a specific file
count_high_low() {
    local file_path="$1"
    local output_file="$2"
    local identifier="$3"  # This will be the GSM identifier

    # Use awk to count unique combinations of 'high' and 'low'
    awk -v id="$identifier" -v OFS="\t" '
        {
            key = $1 FS $2 FS $3 FS $4 FS $5 FS $6 FS $7 FS $8 FS $9 FS $10 FS $11 FS $12;
            if ($13 == "high") high[key]++;
            if ($13 == "low") low[key]++;
        }
        END {
            high_count = length(high);
            low_count = length(low);
            print id, high_count, low_count;
        }' "$file_path" >> "$output_file"
}

while read line
do 
    file_path="/data/slurm/tmmap/chiapet_out/${line}/out/epgwas.bed"
    count_high_low "$file_path" "epgwas_high_low_count.txt" "$line"
done < chiapet.txt

echo "chiapet processing finished"

while read line
do 
    file_path="/data/slurm/tmmap/hichip_out/${line}/epgwas.bed"
    count_high_low "$file_path" "epgwas_high_low_count.txt" "$line"
done < hichip.txt

echo "hichip processing finished"
