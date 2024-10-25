#!/bin/bash

# Path to the input file
input_list="/data/slurm/tmmap/hichip.txt"
E_file="/data/slurm/tmmap/Elength.txt"

# Ensure output files are empty initially
> "$E_file"

# Read each line from the input file
while read line; do  
    # Construct the directory path
    dir_path="/data/slurm/tmmap/hichip_out/${line}/"
    input_file="${dir_path}/ep.bed"

    # Check if the directory and input file exist
    if [[ -d "$dir_path" && -f "$input_file" ]]; then
        echo "Processing GSM: $line"
        cd "$dir_path"

        # Process each line in ep1.bed
        while read -r chromA startA endA chromE startE endE extra; do
            E_length=$((endE - startE))
            echo "$E_length" >> "$E_file"
        done < "$input_file"
    else
        echo "Warning: Directory or input file does not exist for GSM: $line" >&2
    fi
done < "$input_list"

# Path to the input file
input_list="/data/slurm/tmmap/chiapet.txt"
E_file="/data/slurm/tmmap/Elength.txt"

# Read each line from the input file
while read line; do  
    # Construct the directory path
    dir_path="/data/slurm/tmmap/chiapet_out/${line}/out/"
    input_file="${dir_path}/ep.bed"

    # Check if the directory and input file exist
    if [[ -d "$dir_path" && -f "$input_file" ]]; then
        echo "Processing GSM: $line"
        cd "$dir_path"

        # Process each line in ep1.bed
        while read -r chromA startA endA chromE startE endE extra; do
            E_length=$((endE - startE))
            echo "$E_length" >> "$E_file"
        done < "$input_file"
    else
        echo "Warning: Directory or input file does not exist for GSM: $line" >&2
    fi
done < "$input_list"

sort "$E_file" | uniq > "${E_file}.tmp"
mv "${E_file}.tmp" "$E_file"