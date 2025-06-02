#!/bin/bash

start=`date +%s`
echo $HOSTNAME

outpath="References"
mkdir -p ${outpath}
cd ${outpath}

# Check if required files exist
if [ ! -f "gencode.vM37.transcripts.fa.gz" ]; then
    echo "Error: gencode.vM37.transcripts.fa.gz not found"
    exit 1
fi

if [ ! -f "GRCm39.primary_assembly.genome.fa.gz" ]; then
    echo "Error: GRCm39.primary_assembly.genome.fa.gz not found"
    exit 1
fi

if [ ! -f "gencode.vM37.pc_transcripts.fa.gz" ]; then
    echo "Error: gencode.vM37.pc_transcripts.fa.gz not found"
    exit 1
fi

# Generate decoys file as per Alevin tutorial
echo "Generating decoys list..."
grep "^>" <(gunzip -c GRCm39.primary_assembly.genome.fa.gz) | cut -d " " -f 1 > decoys.txt
sed -i -e 's/>//g' decoys.txt

# Create concatenated transcriptome+genome (gentrome)
echo "Creating concatenated gentrome file..."
cat gencode.vM37.transcripts.fa.gz GRCm39.primary_assembly.genome.fa.gz > gentrome.fa.gz

# Create index with decoys
echo "Creating salmon index with decoys..."
INDEX="salmon_gencode.vM37.index.decoy"
call="salmon index -t gentrome.fa.gz -d decoys.txt -i ${INDEX} -k 31 --gencode -p 4"
echo $call
eval $call

# Clean up intermediate files
# rm decoys.txt
#rm gentrome.fa.gz

end=`date +%s`
runtime=$((end-start))
echo "Runtime in seconds: $runtime"