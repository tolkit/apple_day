#!/usr/bin/env bash

input="../apple_genome_paths.txt"
while IFS= read -r FILE; do
    printf "Processing $FILE"
    export FILE
    mbMem=5000
    bsub -n 16 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o busco_$FILE.out ./submit_busco.bash
done < "$input"
