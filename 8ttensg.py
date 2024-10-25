import pandas as pd
import shutil
import os

all = pd.read_csv('/data/slurm/tmmap/all.csv')
allchiapet = all[all['type'] == 'ChIA-PET']
for i in range(len(allchiapet)):
    print("chiapet")
    gsm = allchiapet.iloc[i, 2]
    tf = allchiapet.iloc[i, 6]
    ct = allchiapet.iloc[i, 10]
    source_file = os.path.join(f"/data/slurm/tmmap/chiapet_out/{gsm}/out/ensg.txt")
    target_file = os.path.join("/data/slurm/tmmap/gene", f"{tf}_{ct}_{gsm}.txt")
    try:
        shutil.copy(source_file, target_file)
    except Exception as e:
        print(f"Error copying file {source_file}: {e}")

allhichip = all[all['type'] == 'HiChIP']
for i in range(len(allhichip)):
    print("hichip")
    gsm = allhichip.iloc[i, 2]
    tf = allhichip.iloc[i, 6]
    ct = allhichip.iloc[i, 10]
    source_file = os.path.join(f"/data/slurm/tmmap/hichip_out/{gsm}/ensg.txt")
    target_file = os.path.join("/data/slurm/tmmap/gene", f"{tf}_{ct}_{gsm}.txt")
    try:
        shutil.copy(source_file, target_file)
    except Exception as e:
        print(f"Error copying file {source_file}: {e}")

folder_path = '/data/slurm/tmmap/gene'
bed_files = [f for f in os.listdir(folder_path) if f.endswith('.txt')]
bed_groups = {}

for bed_file in bed_files:
    first_index = bed_file.find('_')
    last_index = bed_file.rfind('_')
    tissue = bed_file[first_index + 1:last_index]
    tf_tissue = bed_file.split('_')[0] + '_' + tissue
    print(tf_tissue)
    gsm = bed_file.split('_')[-1].split('.')[0]

    if tf_tissue not in bed_groups:
        bed_groups[tf_tissue] = []
    bed_groups[tf_tissue].append(gsm)

for tf_tissue, gsms in bed_groups.items():
    with open(os.path.join(folder_path, tf_tissue + '.txt'), 'w') as outfile:
        for gsm in gsms:
            with open(os.path.join(folder_path, tf_tissue + '_' + gsm + '.txt'), 'r') as infile:
                outfile.write(infile.read())
        outfile = outfile.drop_duplicates()

for filename in os.listdir(folder_path):
    if 'GSM' in filename:
        try:
            os.remove(os.path.join(folder_path, filename))
            print(f"Deleted {filename}")
        except Exception as e:
            print(f"Error deleting file {filename}: {e}")