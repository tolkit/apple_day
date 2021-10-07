# minimap2 reference genomes

Turns out you can (obviously) map references to references using minimap2. The PAF files can then be investigated.

Mapping drMalDome5_1.curated_primary.fa vs drMalDome11_1.curated_primary.fa.

```bash
#!/usr/bin/env bash

THREADS=30

# activate minimap
cd /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/bin
source activate root

cd /lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/minimap_pairwise_refs
source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses

# e.g. command
# ./minimap2 -cx asm5 asm1.fa asm2.fa > aln.paf

# test map 5 and 11
minimap2 -t $THREADS -cx asm5 /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa > 5_11_m_domestica.paf
```

And drMalDome5_1.curated_primary.fa vs drMalSylv7_1.curated_primary.fa.

```bash
#!/usr/bin/env bash

THREADS=30

# activate minimap
cd /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/bin
source activate root

cd /lustre/scratch123/tol/teams/blaxter/users/mb39/apple_day/minimap_pairwise_refs
source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses

minimap2 -t $THREADS -cx asm5 /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_sylvestris/assembly/curated/drMalSylv7.1/drMalSylv7_1.curated_primary.fa > 5_syl_m_domestica_sylvestris.paf
```