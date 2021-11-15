#!/usr/bin/env bash

# already made bcfs dir
cd bcfs


for file in ../bams/SRR*.sorted.bam; do
    printf "Processing $file.\n"
    accession=$(basename $file | cut -d. -f1)
    # submit to bsub
    mbMem=6000; bsub -n 30 -q long -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J_${accession}.out -e %J_${accession}.err "cd /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/bin; source activate root; cd /lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/bcfs; source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; bcftools mpileup --threads 30 -Ou -f ../genome/drMalDome5_1.curated_primary.fa $file | bcftools call --threads 30 -mv -Ob -o ${accession}.bcf"
done