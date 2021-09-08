#!/usr/bin/env bash

egrep "^attribute: sample$|AVU" -A1 resequence_metadata.txt | \
egrep -v "^attribute: type$|^attribute: sample$|\-\-" | \
sed 's/AVUs defined for dataObj \/seq\/illumina\/runs\/39\/39617\/.*\///' | \
sed 's/\.cram://' | \
sed 's/value: //' | \
sed 's/attribute: tag_index//' | \
sed '/^[[:space:]]*$/d' | \
sed 'N;s/\n/\t/'
