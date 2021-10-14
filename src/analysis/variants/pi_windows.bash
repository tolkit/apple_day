#!/usr/bin/env bash

vcftools \
--vcf ./data/no_missing_merged.recode.vcf \
--window-pi  10000 \
--out ./data/no_missing_merged_windows