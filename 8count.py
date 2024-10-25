import pandas as pd

# Step 0: Read convert.txt and create a mapping dictionary
convert_df = pd.read_csv('/data/slurm/tmmap/references/convert.txt', sep='\t', header=None)
convert_mapping = dict(zip(convert_df[0], convert_df[1]))

# Read BED file
bed_df = pd.read_csv('allloop.txt', sep='\t', header=None)

# Read Excel file
excel_df = pd.read_excel('all.xlsx')

# Step 1: Pre-process the GSM values and filter the Excel data to reduce computation later
gsm_values_with_annotated = set(excel_df.dropna(subset=['annotated_cell_type'])['GSM'].tolist())

# Step 2: Replace values in column 18 based on matching the part before "." with convert.txt
def replace_based_on_convert(value):
    key_part = value.split('.')[0]  # Get the part before "."
    if key_part in convert_mapping:
        return convert_mapping[key_part]  # Replace with the corresponding value from convert.txt
    return value  # If no match, return the original value

# Apply the replacement function to the 18th column (index 17)
bed_df[17] = bed_df[17].apply(replace_based_on_convert)

# Step 3: Pre-process column 20 as string to avoid repetitive typecasting
bed_df[19] = bed_df[19].astype(str)

# Step 4: Perform all required comparisons in one step, reducing repetitive filtering
high_rows = bed_df[13] == 'high'
subset_rows = bed_df[18].isin({"1a", "1b", "1c", "1d", "1e", "1f", "2a", "2b"})
not_na_rows = bed_df[19] != 'NA'
celltype_enhancer_rows = bed_df[0].isin(gsm_values_with_annotated)

# Step 5: Extract the part after '-' in column 20
bed_df['col_20_suffix'] = bed_df[19].apply(lambda x: ';'.join([part.split('-')[0] for part in x.split(';')]))

# Step 6: Compare column 18 with the suffix part of column 20
matching_18_20_rows = bed_df.apply(lambda row: row[17] == row['col_20_suffix'] or row[17] in row['col_20_suffix'], axis=1)
matching_18_20_count = matching_18_20_rows.sum()
matching_18_20_indices = ';'.join(map(str, bed_df[matching_18_20_rows].index.tolist()))

# Step 7: Count and extract indices in a single pass
high_count = high_rows.sum()
subset_count = subset_rows.sum()
not_na_count = not_na_rows.sum()
celltype_enhancer_count = celltype_enhancer_rows.sum()

high_indices = ';'.join(map(str, bed_df[high_rows].index.tolist()))
subset_indices = ';'.join(map(str, bed_df[subset_rows].index.tolist()))
not_na_indices = ';'.join(map(str, bed_df[not_na_rows].index.tolist()))
celltype_enhancer_indices = ';'.join(map(str, bed_df[celltype_enhancer_rows].index.tolist()))
matching_18_20_indices = ';'.join(map(str, bed_df[matching_18_20_rows].index.tolist()))

# Step 8: Write results to a file
with open('count_results.txt', 'w') as f:
    f.write(f"Category\tTotal Rows\tRow Indices\n")
    f.write(f"Tier 1 loops\t{high_count}\t{high_indices}\n")
    f.write(f"high-score SNPs\t{subset_count}\t{subset_indices}\n")
    f.write(f"eQTL significant SNPs\t{not_na_count}\t{not_na_indices}\n")
    f.write(f"celltype_enhancer\t{celltype_enhancer_count}\t{celltype_enhancer_indices}\n")
    f.write(f"eQTL target gene match loop target gene\t{matching_18_20_count}\t{matching_18_20_indices}\n")

print("Results have been written to count_results.txt")
