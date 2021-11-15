#!/usr/bin/env bash

for file in *.sra; do
    echo "Splitting $file into read pairs."
    sra_folder=$(basename $file | cut -d. -f1)
    mkdir $sra_folder
    cd $sra_folder
    # do the compute
    mbMem=5000; bsub -n 5 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "/software/team301/sratoolkit.2.11.1-ubuntu64/bin/fastq-dump --split-files --fasta 60 ../$file"
    cd ..
done