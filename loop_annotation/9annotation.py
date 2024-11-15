import pandas as pd
import os

def update_epqtl(qtl_dict, input_file, output_file):
    with open(input_file, 'r') as f_in:
        with open(output_file, 'w') as f_out:
            for line in f_in:
                parts = line.strip().split('\t')
                
                # Fetch the QTL values or use 'NA' if not found
                rs_qtl1 = qtl_dict.get(parts[13], ['NA'])  # parts[13] corresponds to the 14th column
                rs_qtl = sorted(set(rs_qtl1))
                
                # If rs_qtl1 contains only 'NA', keep 'NA' as output
                rs_qtl_str = 'NA' if rs_qtl == ['NA'] else ';'.join(rs_qtl)
                
                # Prepare the output line with the QTL values or 'NA'
                output_line = '\t'.join(parts[:19] + [rs_qtl_str])
                f_out.write(output_line + '\n')
    
    # Process the output file to remove the 16th column and save
    df = pd.read_csv(output_file, sep='\t', header=None)
    df.drop(df.columns[15], axis=1, inplace=True)  # Drop the 16th column (zero-indexed 15)
    df.to_csv(output_file, sep='\t', index=False, header=False)


qtl_dict = {}
with open('/data/slurm/tmmap/GWASdataset/all.tsv', 'r') as f:
    for line in f:
        parts = line.strip().split('\t')
        key1 = parts[21]  
        value = parts[7]
        if key1 not in qtl_dict:
            qtl_dict[key1] = []
        qtl_dict[key1].append(value)

with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        try:
            os.chdir(f"/data/slurm/tmmap/hichip_out/{line}/")
            output_path = 'annotation.txt'  # Define output_path here
            open(output_path, 'w').close()
            print(f"start processing {line}")
            update_epqtl(qtl_dict, 'epqtl.txt', output_path)
        except Exception as e:
            print(f"An error occurred while processing {line}: {e}")

with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        line = line.strip()
        try:
            os.chdir(f"/data/slurm/tmmap/chiapet_out/{line}/out/")
            output_path = 'annotation.txt'  # Define output_path here
            open(output_path, 'w').close()
            print(f"start processing {line}")
            update_epqtl(qtl_dict,'epqtl.txt', output_path)
        except Exception as e:
            print(f"An error occurred while processing {line}: {e}")
