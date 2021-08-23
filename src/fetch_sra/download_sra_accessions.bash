#!/usr/bin/env bash

sort -u sra_accessions.txt | \
parallel -j 10 \
"/software/team301/sratoolkit.2.11.1-ubuntu64/bin/prefetch {} --max-size 100GB --force all"