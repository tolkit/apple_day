#!/usr/bin/env bash

# use singularity container

printf "Running BUSCO on $FILE\n"

nm=$(basename $FILE)

/software/singularity-v3.6.4/bin/singularity \
exec \
--bind /lustre:/lustre \
/software/tola/images/busco-5.0.0_cv1.sif \
busco \
-i $FILE \
-l /lustre/scratch123/tol/resources/busco/v5/lineages/eudicots_odb10/ \
-o busco_${nm} \
--mode genome \
--offline \
--cpu 16