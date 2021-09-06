#!/usr/bin/env bash

# Max Brown; Wellcome Sanger Institute 2021

# get the urls
python3 ./scrape_nat_urls.py > nat_urls.txt
# get all the text
python3 ./scrape_nat_data.py > nat_data.txt

# convert this text to useful info
Rscript ./format_nat_data.R

rm ./nat_data.txt ./nat_urls.txt