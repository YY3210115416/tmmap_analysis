import pandas as pd
import os

def update_epqtl(qtl_dict, input_file, output_file):
    with open(input_file, 'r') as f_in:
        with open(output_file, 'w') as f_out:
            for line in f_in:
                parts = line.strip().split('\t')
                rs_key = parts[13]  
                rs_qtl1 = qtl_dict.get(parts[13], ['NA'])
                rs_qtl = sorted(set(rs_qtl1))
                rs_qtl_str = '\t'.join(rs_qtl)
                output_line = '\t'.join(parts[:17] + [rs_qtl_str])
                #print(f"Output line: {output_line}") 
                f_out.write(output_line + '\n')

qtl_dict = {}
with open('/data/slurm/tmmap/references/score.tsv', 'r') as f:
    for line in f:
        parts = line.strip().split('\t')
        key1 = parts[0] 
        key2 = parts[1]  
        value = parts[2]
        if key1 not in qtl_dict:
            qtl_dict[key1] = []
        qtl_dict[key1].append(value)
        if key2 not in qtl_dict:
            qtl_dict[key2] = []
        qtl_dict[key2].append(value)

with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        try:
            os.chdir(f"/data/slurm/tmmap/hichip_out/{line}/")
            output_path = 'eprank.txt'  # Define output_path here
            open(output_path, 'w').close()
            print(f"start processing {line}")
            update_epqtl(qtl_dict, 'epgene.txt', output_path)
        except Exception as e:
            print(f"An error occurred while processing {line}: {e}")

with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        try:
            os.chdir(f"/data/slurm/tmmap/chiapet_out/{line}/out/")
            output_path = 'eprank.txt'  # Define output_path here
            open(output_path, 'w').close()
            print(f"start processing {line}")
            update_epqtl(qtl_dict,'epgene.txt', output_path)
        except Exception as e:
            print(f"An error occurred while processing {line}: {e}")
