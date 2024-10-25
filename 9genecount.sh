#!/bin/bash

# Step 1: Extract columns 5, 6, 7, 17 from allloop.txt, remove duplicate rows, and calculate ngenes
mawk -F'\t' '{
    # Print columns 5, 6, 7, 17
    print $5, $6, $7, $17
}' OFS='\t' "allloop.txt" | sort -u > "genes_unique.txt"  # Sort and remove duplicates

# Calculate ngenes (number of unique genes)
mawk -F'\t' '{
    # Split the 4th column (column 17 from original file) by ";"
    n_genes = split($4, genes, ";");
    print n_genes  # Print the number of genes
}' OFS='\t' "genes_unique.txt" > "genecount_tmp.txt"  # Output only the gene count

# Step 2: Extract columns 15, 20 from allloop.txt, remove duplicate rows, and calculate nqtls
mawk -F'\t' '{
    # Print columns 15 and 20
    print $15, $20
}' OFS='\t' "allloop.txt" | sort -u > "qtls_unique.txt"  # Sort and remove duplicates

# Calculate nqtls (number of unique QTLs)
mawk -F'\t' '{
    # Split the 2nd column (column 20 from original file) by ";"
    n_qtls = split($2, qtls, ";");
    print n_qtls  # Print the number of QTLs
}' OFS='\t' "qtls_unique.txt" > "qtlscount_tmp.txt"  # Output only the QTL count

# Step 3: Combine ngenes and nqtls into one file
paste "genecount_tmp.txt" "qtlscount_tmp.txt" > "genecount.txt"

# Clean up temporary files
rm "genecount_tmp.txt" "qtlscount_tmp.txt" "genes_unique.txt" "qtls_unique.txt"

echo "Gene and QTL counts have been written to genecount.txt."
