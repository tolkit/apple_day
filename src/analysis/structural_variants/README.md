# Identifying structural variants

## Assemblies

The assembly team, using Hi-C data:

- drMalDome58: Inversions between haplotypes observed in chromosomes 1 5.49-7.32mb, 11 31.38-33.79mb, 12 10.26-14.45mb, 13 34.66-35.91mb and 17 22.1-25.48mb
* - drMalDome5: From the Hi-C data, inversions between haplotypes can be seen on chromosome 4 11.13-14.86mb, chromosome 6 13.34-17.21mb, chromosome 11 22.9-24.24mb and 30.06-32.57mb, chromosome 12 10.9-11.98mb, chromosome 13 34-37mb
- drMalDome10: Shared sequences between chromosomes are visible in the Hi-C map in agreement with the findings of https://doi.org/10.1038/ng.654. Evidence of inversions between haplotypes from the Hi-C map in chromosome 4 21.72-23.32mb, chromosome 5 14.44-16.4mb and chromosome 11 30.76-33.27
- drMalDome11: Shared sequences between chromosomes are visible in the Hi-C map in agreement with the findings of https://doi.org/10.1038/ng.654. Evidence of inversions between haplotypes from the Hi-C map in chromosome 1 1.28-7.73mb and chromosome 5 14.88-16.83mb.
- 

## SV pipeline

Between haplotypes. Mapping raw ccs reads -> assembly. Use ngmlr and sniffles to call variants.

Step 1:

Copied over one of the raw HiFi filtered readsets to a `data_renamed` directory.

```bash
for file in /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/genomic_data/drMalDome{5,10,11,58}/pacbio/fasta/*.filtered.fasta.gz; do

	nm=$(echo $file | cut -d/ -f11)
	id=$(echo $file | cut -d/ -f14 | cut -d. -f1)

	echo "$nm    $id: Copying..."
	cp $file ./data/${nm}_${id}.filtered.fasta.gz
done
```

```bash
for id in {5,10,11,58}; do

	mbMem=5000; bsub -n 16 -q long -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "./ngmlr-0.2.7/ngmlr -t 16 -r /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome${id}.1/drMalDome${id}_1.curated_primary.fa -q ./data_renamed/drMalDome${id}.filtered.fasta.gz -o ./drMalDome${id}.sam"

done
```

Got to sort the sam files, convert to bam. E.g.

```bash
mbMem=5000; bsub -n 20 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; for i in {10,11,58}; do samtools sort -@ 20 drMalDome${i}.sam -o ./bams/drMalDome${i}_sorted.bam; done"
```

Weirdly, have to downgrade samtools here to 1.9... some bug in nglmr I think. This is the sniffles command.

```bash
./Sniffles-master/bin/sniffles-core-1.0.12/sniffles -m drMalDome5_sorted.bam -v drMalDome5_sniffles.vcf -t 16
```

I also used bcftools to get a VCF of SNP's for nucleotide diversity (the only file in `../bams/*.bam` was drMalDome5, aka Costard):

```bash
for file in ../bams/*.bam; do
    printf "Processing $file.\n"
    accession=$(basename $file | cut -d. -f1)
    # submit to bsub
    mbMem=6000; bsub -n 30 -q long -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J_${accession}.out -e %J_${accession}.err "source activate /lustre/scratch123/tol/teams/blaxter/users/mb39/miniconda3/envs/apple_analyses; bcftools mpileup --threads 30 -Ou -f ../../genome/drMalDome5_1.curated_primary.fa $file | bcftools call --threads 30 -mv -Ob -o ${accession}.bcf"
done
```

bcftools view -i '%QUAL>=20' -o drMalDome5_sorted_filtered.vcf drMalDome5_sorted.bcf

vcftools --vcf drMalDome5_sorted_filtered.vcf --max-missing 1.0 --out no_missing --recode --recode-INFO-all

Then using vcftools:

```bash
vcftools --vcf no_missing.recode.vcf --window-pi 10000 --out drMalDome5_windows_filtered_no_missing
```

## Different SV pipeline

Perhaps the assemblies can be mapped to detect structural variation between species. Minimap2 can align genomes into a PAF? These can then be turned into a GFA using miniasm?

See https://github.com/lh3/minimap2/blob/fe35e679e95d936698e9e937acc48983f16253d6/cookbook.md

Also what about Newton's triploid assembly..?