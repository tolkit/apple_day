#!/usr/bin/env bash

# full tables
rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/buscos/*full_table.tsv ./data/
# stats
for file in /lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/buscos/busco_drMalDome{5,10,11,58}_1.curated_primary.fa/; do
    rsync -avhP f:${file}short_summary.specific* ./data/
done

rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/buscos/busco_drMalSylv7_1.curated_primary.fa/short_summary.specific* ./data/
