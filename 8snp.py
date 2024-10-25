import os
import pandas as pd

def process_file(file_path):
    try:
        positions = set()
        rsids = set()

        df = pd.read_csv(file_path, sep='\t', header=None, dtype={7: str})  # Specify dtype for column 8
        for item in df[7].dropna():
            if item.startswith('chr'):  # Positions start with 'chr'
                positions.add(item)
            elif item.startswith('rs'):  # rsids start with 'rs'
                rsids.add(item)

        with open('/data/slurm/tmmap/snp.txt', 'a') as f_out:
            for item in positions:
                f_out.write(item + '\n')
            for item in rsids:
                f_out.write(item + '\n')

    except Exception as e:
        print(f"Error processing {file_path}: {e}")

        
def remove_duplicates_and_write(file_path):
    try:
        # Read the file to a set to automatically remove duplicates
        with open(file_path, 'r') as file:
            unique_rsids = set(file.read().strip().split('\n'))

        # Write the unique RSIDs back to the file
        with open(file_path, 'w') as file:
            for rsid in sorted(unique_rsids):
                file.write(rsid + '\n')
        print("Duplicates removed and unique RSIDs have been written.")
    except Exception as e:
        print(f"Error during removing duplicates: {e}")

with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        print(f"{line} processing")
        os.chdir(f"/data/slurm/tmmap/hichip_out/{line}/")
        process_file('epgene.txt')
        print(f"{line} RSIDs have been written to snp.txt file.")

with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        print(f"{line} processing")
        os.chdir(f"/data/slurm/tmmap/chiapet_out/{line}/out/")
        process_file('epgene.txt')
        print(f"{line} RSIDs have been written to snp.txt file.")

# Call the function to remove duplicates from the RSIDs file
remove_duplicates_and_write('/data/slurm/tmmap/snp.txt')
