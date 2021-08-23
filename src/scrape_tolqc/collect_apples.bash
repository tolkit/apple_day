#!/usr/bin/env bash

# Max Brown; Wellcome Sanger Institute 2021

# Usage: python3 scrape_tolqc_apples.py <apple_name> <out_dir>

python3 scrape_tolqc_apples.py Malus_domestica ../../data/tolqc_data/species_raw
python3 scrape_tolqc_apples.py Malus_sylvestris ../../data/tolqc_data/species_raw
python3 scrape_tolqc_apples.py Malus_x_robusta ../../data/tolqc_data/species_raw