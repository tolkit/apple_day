#!/usr/bin/env bash

# don't want to download EVERYTHING
# the kmer tsv's are particularly big
# if I do later, then this works:
# rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/fasta_windows_output/fw_out/* .

rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/fasta_windows_output/fw_out/drMalDome5_windows.tsv ./data
rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/fasta_windows_output/fw_out/drMalDome10_windows.tsv ./data
rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/fasta_windows_output/fw_out/drMalDome11_windows.tsv ./data
rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/fasta_windows_output/fw_out/drMalDome58_windows.tsv ./data
rsync -avhP f:/lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/fasta_windows_output/fw_out/drMalSylv7_windows.tsv ./data
