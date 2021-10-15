#!/usr/bin/env bash

# using https://github.com/tolkit/mmft

printf "Getting lengths.\n"

/software/team301/mmft/mmft len /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome10.1/drMalDome10_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome58.1/drMalDome58_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_sylvestris/assembly/curated/drMalSylv7.1/drMalSylv7_1.curated_primary.fa > apple_genome_lengths.tsv

printf "Lengths calculated.\nGetting GC content.\n"

/software/team301/mmft/mmft gc /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome10.1/drMalDome10_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome58.1/drMalDome58_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_sylvestris/assembly/curated/drMalSylv7.1/drMalSylv7_1.curated_primary.fa > apple_genome_gc.tsv

printf "GC's calculated.\nGetting n50's.\n"

/software/team301/mmft/mmft n50 /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome10.1/drMalDome10_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome58.1/drMalDome58_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_sylvestris/assembly/curated/drMalSylv7.1/drMalSylv7_1.curated_primary.fa > apple_genome_n50.tsv

printf "n50's calculated.\nGetting number of seqs/bases.\n"

/software/team301/mmft/mmft num /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome10.1/drMalDome10_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome58.1/drMalDome58_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_sylvestris/assembly/curated/drMalSylv7.1/drMalSylv7_1.curated_primary.fa > apple_genome_nums.tsv

printf "All done.\n"


