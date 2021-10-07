#!/usr/bin/env bash

vcftools \
--vcf no_missing_merged.recode.vcf \
--window-pi  10000 \
--out no_missing_merged_windows