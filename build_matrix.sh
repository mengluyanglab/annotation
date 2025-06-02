#!/bin/bash

# Get sample names from directory structure
samples=$(ls -d quants/*_quant | sed 's|quants/||' | sed 's/_quant$//' | tr '\n' ' ')
first_sample=${samples%% *}

# Extract header (transcript IDs)
awk 'NR>1 {print $1}' quants/${first_sample}_quant/quant.sf > transcript_ids.txt

# Initialize output
cp transcript_ids.txt numreads_matrix.txt

# Loop through each sample
for sample in $samples; do
    echo "Processing $sample..."
    awk -v sample=$sample 'NR>1 {print $4}' quants/${sample}_quant/quant.sf > tmp_numreads.txt
    paste numreads_matrix.txt tmp_numreads.txt > tmp && mv tmp numreads_matrix.txt
done

# Add header
echo -e "Name\t${samples// /\\t}" | cat - numreads_matrix.txt > matrix.csv

# Clean up
rm transcript_ids.txt tmp_numreads.txt numreads_matrix.txt

echo "Matrix has been created as matrix.csv"

