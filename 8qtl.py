import os
import pandas as pd

# Initialize the set for all unique qtls
all_unique_qtls = set()

# Processing HiChIP data
with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        file_path = f"/data/slurm/tmmap/hichip_out/{line}/epqtl.txt"
        try:
            df = pd.read_csv(file_path, sep='\t', header=None)
            unique_qtls = set()
            for items in df[18].dropna():
                for item in items.split(';'):
                    qtl = item.split('-')[-1]
                    unique_qtls.add(qtl)
            all_unique_qtls.update(unique_qtls)

            with open(f"/data/slurm/tmmap/hichip_out/{line}/qtl.txt", 'w') as f_out:
                for qtl in unique_qtls:
                    f_out.write(qtl + '\n')
            print(f"{line} qtl names have been written to qtl.txt file.")
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

# Processing ChIA-PET data
with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        file_path = f"/data/slurm/tmmap/chiapet_out/{line}/out/epqtl.txt"
        try:
            df = pd.read_csv(file_path, sep='\t', header=None)
            unique_qtls = set()
            for items in df[18].dropna():
                for item in items.split(';'):
                    qtl = item.split('-')[-1]
                    unique_qtls.add(qtl)
            all_unique_qtls.update(unique_qtls)

            with open(f"/data/slurm/tmmap/chiapet_out/{line}/out/qtl.txt", 'w') as f_out:
                for qtl in unique_qtls:
                    f_out.write(qtl + '\n')
            print(f"{line} qtl names have been written to qtl.txt file.")
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

# Write all unique qtls collected from all directories to the base qtl file
with open('/data/slurm/tmmap/qtl.txt', 'w') as f_out:
    for qtl in all_unique_qtls:
        f_out.write(qtl + '\n')
print("All unique qtl names have been compiled into /data/slurm/tmmap/qtl.txt.")
