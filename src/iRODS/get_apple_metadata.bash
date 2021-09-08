#!/usr/bin/env bash

while read -r line
do
    imeta ls -d $line
done < ./apple_cram_paths.txt