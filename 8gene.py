import os
import pandas as pd

# Initialize the set for all unique genes
all_unique_genes = set()

# Processing HiChIP data
with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        file_path = f"/data/slurm/tmmap/hichip_out/{line}/epqtl.txt"
        try:
            df = pd.read_csv(file_path, sep='\t', header=None)
            unique_genes = set(item for items in df[16].dropna() for item in items.split(';'))
            all_unique_genes.update(unique_genes)

            with open(f"/data/slurm/tmmap/hichip_out/{line}/gene.txt", 'w') as f_out:
                for gene in unique_genes:
                    f_out.write(gene + '\n')
            print(f"{line} Gene names have been written to gene.txt file.")
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

# Processing ChIA-PET data
with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        file_path = f"/data/slurm/tmmap/chiapet_out/{line}/out/epqtl.txt"
        try:
            df = pd.read_csv(file_path, sep='\t', header=None)
            unique_genes = set(item for items in df[16].dropna() for item in items.split(';'))
            all_unique_genes.update(unique_genes)

            with open(f"/data/slurm/tmmap/chiapet_out/{line}/out/gene.txt", 'w') as f_out:
                for gene in unique_genes:
                    f_out.write(gene + '\n')
            print(f"{line} Gene names have been written to gene.txt file.")
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

# Write all unique genes collected from all directories to the base gene file
with open('/data/slurm/tmmap/gene.txt', 'w') as f_out:
    for gene in all_unique_genes:
        f_out.write(gene + '\n')
print("All unique gene names have been compiled into /data/slurm/tmmap/gene.txt.")