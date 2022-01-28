#!/usr/bin/env bash

source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses

# already done
# mkdir filtered_bcfs

for bcf in ./SRR*.bcf; do
    nm=$(basename $bcf | cut -d. -f1)
    echo "Processing $bcf now."
    bcftools view -i '%QUAL>=20' -o ./filtered_bcfs/${nm}_filtered.bcf $bcf
done