#!/usr/bin/env bash

# we already made the directory
# mkdir bams
cd bams

THREADS=30

for dir in ../../SRA/DOWNLOADS/sra/*/; do
    # reads 1 & 2
    reads1="$dir*_1.fasta"
    reads2="$dir*_2.fasta"
    # so we can name them
    nm=$(basename $reads1 | cut -d. -f1 | cut -d_ -f1)
    mbMem=6000; bsub -n 30 -q basement -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J_${index}_update.out -e %J_${index}_update.err "cd /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/bin; source activate root; cd /lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/bams; source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; minimap2 -ax sr -t $THREADS /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa $reads1 $reads2 | samtools view -b - | samtools sort --threads $THREADS - > ${nm}.sorted.bam"
done
