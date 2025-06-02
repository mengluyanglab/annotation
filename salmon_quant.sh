#!/bin/bash

# Go to the parent directory where the output will be saved
cd ../

# Create output directory if it doesn't exist
mkdir -p quants

# Loop through all directories in 01.RawData
for dir in 01.RawData/*/; do
    # Extract the directory name without the path
    samp=$(basename "$dir")
    echo "Processing sample ${samp}"
    
    # Run salmon quant with the specified input files
    salmon quant -i References/salmon_gencode.vM37.index.no.decoy -l A \
        -1 "01.RawData/${samp}/output_forward_paired.fq.gz" \
        -2 "01.RawData/${samp}/output_reverse_paired.fq.gz" \
        -p 4 --validateMappings -o "quants/${samp}_quant"
done
