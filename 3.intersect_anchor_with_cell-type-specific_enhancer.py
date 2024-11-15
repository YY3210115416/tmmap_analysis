import pandas as pd
import subprocess
import os

def run_bedtools_intersect(gsm_id, cell_type, enhancers_dir, out_dir, data_type):
    enhancer_bed_path = os.path.join(enhancers_dir, f"{cell_type}.hg38.bed")
    
    if data_type == "HiChIP":
        gsm_dir = os.path.join(out_dir, gsm_id)
    elif data_type == "ChIA-PET":
        gsm_dir = os.path.join(out_dir.replace("GSM*", gsm_id))
    
    if not os.path.isdir(gsm_dir):
        print(f"GSM directory does not exist: {gsm_dir}")
        return

    anchor1_bed_path = os.path.join(gsm_dir, "anchor1.bed")
    anchor2_bed_path = os.path.join(gsm_dir, "anchor2.bed")
    
    output1_path = os.path.join(gsm_dir, f"anchor1_E.bed")
    output2_path = os.path.join(gsm_dir, f"anchor2_E.bed")
    
    with open(output1_path, 'w') as output1:
        subprocess.run(["bedtools", "intersect", "-a", anchor1_bed_path, "-b", enhancer_bed_path, "-wo"], stdout=output1)
    
    with open(output2_path, 'w') as output2:
        subprocess.run(["bedtools", "intersect", "-a", anchor2_bed_path, "-b", enhancer_bed_path, "-wo"], stdout=output2)
        
    print(f"Successfully processed GSM{gsm_id}")

def process_gsm_data(xlsx_path, enhancers_dir, hichip_out_dir, chiapet_out_dir_pattern):
    df = pd.read_excel(xlsx_path)

    for index, row in df.iterrows():
        gsm_id = row['GSM']
        cell_type = row['annotated_cell_type']
        data_type = row['type']
        
        if pd.notnull(cell_type):
            if data_type == "HiChIP":
                out_dir = hichip_out_dir
            elif data_type == "ChIA-PET":
                out_dir = chiapet_out_dir_pattern
            else:
                print(f"Unknown data type for GSM{gsm_id}: {data_type}")
                continue
            
            try:
                run_bedtools_intersect(gsm_id, cell_type, enhancers_dir, out_dir, data_type)
            except Exception as e:
                print(f"Error processing {gsm_id}: {e}")
                continue

def main():
    xlsx_path = "/data/slurm/tmmap/all.xlsx"
    enhancers_dir = "/data/slurm/tmmap/references/Enhancer/BED_hg38/"
    hichip_out_dir = "/data/slurm/tmmap/hichip_out/"
    chiapet_out_dir_pattern = "/data/slurm/tmmap/chiapet_out/GSM*/out/"

    # Process GSM data
    print("Processing GSM data...")
    process_gsm_data(xlsx_path, enhancers_dir, hichip_out_dir, chiapet_out_dir_pattern)

main()
