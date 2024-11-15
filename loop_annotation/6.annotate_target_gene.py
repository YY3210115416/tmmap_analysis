import pandas as pd
import os

def update_epgwas(enhancer_dict, promoter_dict, input_file, output_file):
    with open(input_file, 'r') as f_in:
        with open(output_file, 'w') as f_out:
            for line in f_in:
                parts = line.strip().split('\t')
                if len(parts) < 9:
                    print(f"Skipping malformed line: {line}")
                    continue
                enhancer_key = (parts[3], int(parts[4]), int(parts[5]))
                promoter_key = (parts[9], int(parts[10]), int(parts[11]))
                enhancer_genes = enhancer_dict.get(enhancer_key, ['NA'])  # Replace with 'NA' if key not found
                promoter_genes = promoter_dict.get(promoter_key, ['NA'])  # Replace with 'NA' if key not found
                
                enhancer_genes = sorted(set(enhancer_genes))
                promoter_genes = sorted(set(promoter_genes))
                
                enhancer_gene_str = ';'.join(enhancer_genes)
                promoter_gene_str = ';'.join(promoter_genes)
                #print(f"E: ",enhancer_gene_str)
                #print(f"P: ",promoter_gene_str)
                output_line = '\t'.join(parts[:15] + [enhancer_gene_str, promoter_gene_str])
                #print(f"Output line: {output_line}") 
                f_out.write(output_line + '\n')


# Merge promoter files
#merge_files(['promoter.txt'], 'promoter.txt')

# Load data once and create dictionaries
enhancer_dict = {}
promoter_dict = {}
with open('/data/slurm/tmmap/references/egene.bed', 'r') as f:
    for line in f:
        parts = line.strip().split('\t')
        key = (parts[0], int(parts[1]), int(parts[2]))
        gene = parts[3]
        if key in enhancer_dict:
            enhancer_dict[key].append(gene)
        else:
            enhancer_dict[key] = [gene]

with open('/data/slurm/tmmap/references/pgene2.bed', 'r') as f:
    for line in f:
        parts = line.strip().split('\t')
        key = (parts[0], int(parts[1]), int(parts[2]))
        gene = parts[3]
        if key in promoter_dict:
            promoter_dict[key].append(gene)
        else:
            promoter_dict[key] = [gene]

with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        try:
            os.chdir(f"/data/slurm/tmmap/hichip_out/{line}/")
            output_path = 'epgene.txt'  # Define output_path here
            open(output_path, 'w').close()
            update_epgwas(enhancer_dict, promoter_dict, 'epgwas.bed', output_path)
            print(f"Finished processing {line}")
        except Exception as e:
            print(f"An error occurred while processing {line}: {e}")

with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        try:
            os.chdir(f"/data/slurm/tmmap/chiapet_out/{line}/out/")
            output_path = 'epgene.txt'  # Define output_path here
            open(output_path, 'w').close()
            update_epgwas(enhancer_dict, promoter_dict, 'epgwas.bed', output_path)
            print(f"Finished processing {line}")
        except Exception as e:
            print(f"An error occurred while processing {line}: {e}")
