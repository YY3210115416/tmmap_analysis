import os

def remove_duplicates_and_write(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    unique_lines = list(set(lines))

    with open(file_path, 'w') as file:
        file.writelines(unique_lines)

def merge_bed_files_with_extra_columns_and_remove_duplicates(anchor_path, anchor_E_path, anchor_P_path, output_path):
    #anchor.bed
    anchor_dict = {}
    with open(anchor_path, 'r') as file:
        for line in file:
            parts = line.strip().split()
            a_number = parts[3][1:] 
            anchor_dict[a_number] = parts
    #anchor_E.bed
    anchor_E_dict = {}
    with open(anchor_E_path, 'r') as file:
        for line in file:
            parts = line.strip().split()
            a_number = parts[3][1:] 
            anchor_E_dict[a_number] = parts
    #anchor_P.bed
    with open(anchor_P_path, 'r') as anchor_P_file, open(output_path, 'a') as output_file:
        for line in anchor_P_file:
            parts = line.strip().split()
            A_number = parts[3][1:]  #'A'

            if A_number in anchor_E_dict:
                anchor_E_parts = anchor_E_dict[A_number]
                if anchor_E_parts[0] == parts[0]:
                    anchor_E_columns = "\t".join(anchor_E_parts[0:3])+"\t"+"\t".join(anchor_E_parts[4:7])
                    parts_columns = "\t".join(parts[0:3])+"\t"+"\t".join(parts[4:7])
                    merged_line = anchor_E_columns + "\t" + parts_columns + "\thigh\n"
                    output_file.write(merged_line)

            elif A_number in anchor_dict:
                anchor_parts = anchor_dict[A_number]
                if anchor_parts[0] == parts[0]:
                    anchor_columns = "\t".join(anchor_parts[0:3])+"\t"+"\t".join(anchor_parts[0:3])
                    parts_columns = "\t".join(parts[0:3])+"\t"+"\t".join(parts[4:7])
                    merged_line = anchor_columns + "\t" + parts_columns + "\tlow\n"
                    output_file.write(merged_line)


anchor1_E_path = "anchor1_E.bed"
anchor1_path = "anchor1.bed"
anchor2_P_path = "anchor2_P.bed"
anchor2_E_path = "anchor2_E.bed"
anchor2_path = "anchor2.bed"
anchor1_P_path = "anchor1_P.bed"
output_path = "ep.bed"

with open("/data/slurm/tmmap/hichip.txt", "r") as list_file:
    for line in list_file:
        try:
            line = line.strip()
            os.chdir(f"/data/slurm/tmmap/hichip_out/{line}/")
            open(output_path, 'w').close()
            merge_bed_files_with_extra_columns_and_remove_duplicates(anchor1_path, anchor1_E_path, anchor2_P_path, output_path)
            merge_bed_files_with_extra_columns_and_remove_duplicates(anchor2_path, anchor2_E_path, anchor1_P_path, output_path)
            
            remove_duplicates_and_write(output_path)
            print(f"Finished processing {line}")
        except Exception as e:
            print(f"Error processing {line}: {e}")

with open("/data/slurm/tmmap/chiapet.txt", "r") as list_file:
    for line in list_file:
        try:
            line = line.strip()
            os.chdir(f"/data/slurm/tmmap/chiapet_out/{line}/out/")
            open(output_path, 'w').close()
            merge_bed_files_with_extra_columns_and_remove_duplicates(anchor1_path, anchor1_E_path, anchor2_P_path, output_path)
            merge_bed_files_with_extra_columns_and_remove_duplicates(anchor2_path, anchor2_E_path, anchor1_P_path, output_path)
            
            remove_duplicates_and_write(output_path)
            print(f"Finished processing {line}")
        except Exception as e:
            print(f"Error processing {line}: {e}")
