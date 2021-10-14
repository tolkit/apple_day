# Analysis notes

## Overview

### Initial analyses

- Statistics in windows across the genome
  - Software: fasta_windows
  - Are all of the chromosomes labelled the same? So can we do some primitive aggregating analyses.
  - Do some plots - are the overall patterns the same between the five assemblies?
- Mapping the cultivars
  - Software: minimap2, samtools, bcftools
  - Map each of the 53 cultivar samples to drMalDome5 - Costard.
  - Call variants
  - Do some clustering analysis; add in some apple metadata
  - Runs of homozygosity?

### Analyses for later
- Whole genome alignment
  - Software: Progressive Cactus
  - Rowan outgroup?
- Newton's Triploid Apple
  - Software: ?
  - Get phased information (even partial), get alleles out in blocks and build trees.

## Statistics in windows

This requires fasta_windows in your path (as ./fw here). 

`fw_compute.bash`

```bash
#!/usr/bin/env bash

while read F; do
	# get name
	nm=$(echo "$F" | cut -d / -f12 | cut -d . -f1)
	# copy genome to current dir
	cp $F ./${nm}.fa
        ./fw -d -f ${nm}.fa -o $nm
	rm ${nm}.fa
done < ../apple_genome_paths.txt
```

## Cultivar mapping and variant calling (on farm)

### Mapping

The location of the apples currently is in the curated folder e.g.:

`/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa`

I'll use minimap2. This creates ~53 separate submissions via `bsub`. I say ~53, as not all indexes have corresponding sequences.

```bash
#!/usr/bin/env bash

# conda create -n apple_analyses
# conda activate apple_analyses
# conda install -c bioconda minimap2 samtools # for now
# source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses
# test e.g. minimap2 works
# echo "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; minimap2" >> test.bash && bash test.bash; rm test.bash

mkdir bams
cd bams

THREADS=30

for index in {1..53}; do
    printf "The index is $index\n"

    apple_day_no=$(grep "#${index}$(printf '\t')" ../iRODS_samples.txt | awk '{print $2}')
    
    mbMem=6000; bsub -n 30 -q long -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J_${index}.out -e %J_${index}.err "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; minimap2 -ax sr -t $THREADS /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa ../fastqs/39617#"${index}"/39617#"${index}"_1.R1.fq.gz ../fastqs/39617#"${index}"/39617#"${index}"_1.R2.fq.gz | samtools view -b - | samtools sort --threads $THREADS - > ${apple_day_no}.sorted.bam"
done

```

### Variant Calling

So I have made not all, but most of the bams. Let's get the commands right for calling variants. I'll use bcftools.

```bash
#!/usr/bin/env bash

mkdir genome
cd genome

# copy the reference genome to genome dir
cp /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa .

samtools faidx drMalDome5_1.curated_primary.fa
```

```bash
#!/usr/bin/env bash

# make the bcf dir
# and descend
mkdir bcfs
cd bcfs

# for some things, might need to remove the -v flag?

for file in ../bams/Apple*; do
    printf "Processing $file.\n"
    accession=$(basename $file | cut -d. -f1)
    # submit to bsub
    mbMem=6000; bsub -n 30 -q long -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J_${accession}.out -e %J_${accession}.err "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; bcftools mpileup --threads 30 -Ou -f ../genome/drMalDome5_1.curated_primary.fa $file | bcftools call --threads 30 -mv -Ob -o ${accession}.bcf"
done

```

Filter the VCF's? Quality?

```bash
#!/usr/bin/env bash

source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses

mkdir filtered_bcfs

for bcf in ./*.bcf; do
        nm=$(basename $bcf | cut -d. -f1)
	echo "Processing $bcf now."
        bcftools view -i '%QUAL>=20' -o ./filtered_bcfs/${nm}_filtered.bcf $bcf
done
```

Combine the calls. First index each bcf.

```bash
#!/usr/bin/env bash
# this is pretty quick, so I just did it on the head node. Shh.
for bcf in ./*.bcf; do bcftools index $bcf; done
```

Then merge. 

```bash
# make merge.txt
for file in ./*.bcf; do echo $file; done > merge.txt

mbMem=5000; bsub -n 20 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; bcftools merge -l merge.txt --threads 20 -Oz -o merged.vcf.gz"
```

### Analysis

Remove missing sites.

```bash 
# filter out so only sites present across all mapped individuals
mbMem=5000; bsub -n 20 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; vcftools --gzvcf merged.vcf.gz --max-missing 1.0 --out no_missing_merged --recode --recode-INFO-all"
# file is no_missing_merged.recode.vcf
```

#### Diversity in windows

See `/variants`.

#### Synteny between cultivars & crab apple

See `/minimap2`.

#### Statistics in windows across the genomes

See `/fw`.