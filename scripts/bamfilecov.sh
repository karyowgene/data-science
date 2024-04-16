#!/bin/bash

set -e

# Replace "path/to/bams" with the path to the directory containing your BAM files
BAM_DIR="/yourfolder/bamfiles"

# Create an output file to store the mean coverage results
OUTPUT_FILE="mean_coverage_results.txt"
echo "BAM_FILE MEAN_COVERAGE" > "$OUTPUT_FILE"

# Loop through each BAM file in the directory
for bam_file in "${BAM_DIR}"/*.bam; do
  # Index the BAM file
  samtools index "$bam_file"
  
  # Calculate the mean depth of coverage
  mean_coverage=$(samtools depth "$bam_file" | awk '{sum += $3} END {print sum / NR}')
  
  # Append the result to the output file
  echo "$bam_file $mean_coverage" >> "$OUTPUT_FILE"
done