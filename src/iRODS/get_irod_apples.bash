#!/usr/bin/env bash

# iinit - this command is needed to be run when you first do this

imeta qu -z seq -d study = 'DTOL_Apple Day' and target = 1 and manual_qc = 1 > ./apple_meta.txt

printf "Downloaded DToL Apple Day Project sequence metadata.\n"

# remove ----'s, collection: and dataObj: from the start of each line
# then merge adjacent lines
grep -v "\-\-\-\-" ./apple_meta.txt | \
sed -e 's/collection: //g' | \
sed -e 's/dataObj: //g' | \
awk 'NR % 2 == 1 { o=$0 ; next } { print o "/" $0 }' > ./apple_cram_paths.txt

printf "Created paths from metadata.\n"

while read path; do
    iget $path
    echo "$path downloaded."
done <./apple_cram_paths.txt