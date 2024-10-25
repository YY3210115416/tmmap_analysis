#!/bin/bash

> /data/slurm/tmmap/nhl.txt

# Path to the input file
input_list="/data/slurm/tmmap/hichip.txt"
output_file="/data/slurm/tmmap/nhl.txt"

# Read each line from the input file
while read line; do  
    # Enable error handling within the subshell
    (
        set -e
        echo "Processing GSM: $line"
        cd /data/slurm/tmmap/hichip_out/${line}/;

        input_file="ep.bed"

        # Attempt to count occurrences of 'low' and 'high', capturing any errors
        low_count=$(grep -c 'low' $input_file 2>&1)
        high_count=$(grep -c 'high' $input_file 2>&1)
        
        # Append the results to the output file using a tab as the separator
        echo "${line}\t${high_count}\t${low_count}" >> $output_file
    ) 2>&1 || {
        # If an error occurs, print it directly
        echo "An error occurred processing GSM: $line"
        echo "Error details:"
        if [[ "${low_count}" =~ ^[0-9]+$ ]]; then
            echo -e "Low count: ${low_count}"
        else
            echo "${low_count}"  # This will display the error if grep for 'low' failed
        fi
        if [[ "${high_count}" =~ ^[0-9]+$ ]]; then
            echo -e "High count: ${high_count}"
        else
            echo "${high_count}" # This will display the error if grep for 'high' failed
        fi
    }

done < $input_list

# Path to the input file
input_list="/data/slurm/tmmap/chiapet.txt"
output_file="/data/slurm/tmmap/nhl.txt"

# Read each line from the input file
while read line; do  
    # Enable error handling within the subshell
    (
        set -e
        echo "Processing GSM: $line"
        cd /data/slurm/tmmap/chiapet_out/${line}/out;

        input_file="ep.bed"

        # Attempt to count occurrences of 'low' and 'high', capturing any errors
        low_count=$(grep -c 'low' $input_file 2>&1)
        high_count=$(grep -c 'high' $input_file 2>&1)
        
        # Append the results to the output file using a tab as the separator
        echo "${line}\t${high_count}\t${low_count}" >> $output_file
    ) 2>&1 || {
        # If an error occurs, print it directly
        echo "An error occurred processing GSM: $line"
        echo "Error details:"
        if [[ "${low_count}" =~ ^[0-9]+$ ]]; then
            echo "Low count: ${low_count}"
        else
            echo "${low_count}"  # This will display the error if grep for 'low' failed
        fi
        if [[ "${high_count}" =~ ^[0-9]+$ ]]; then
            echo -e "High count: ${high_count}"
        else
            echo "${high_count}" # This will display the error if grep for 'high' failed
        fi
    }

done < $input_list
