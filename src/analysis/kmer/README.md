# Kmer spectra

The genome of the 'Flower of Kent' cultivar is triploid. Something which may give us an indication of whether this genome is auto/allo triploid is the kmer spectra of the raw reads. This is drMalDome58.

For data on the farm, see `apple_day/structural_variants/data/drMalDome58_*.fasta.gz`

FastK will compute the histogram:

```bash
/software/team301/FASTK/FastK -t16 -k21 ../structural_variants/data/drMalDome58_m64*.fasta.gz
/software/team301/FASTK/Histex -h10000 drMalDome58_m64016e_210808_072016.filtered.hist > drMalDome58_m64016e_210808_072016.filtered_hist.txt
```

`39617#13_1.R{1,2}.fq.gz` (-> `sanger_newton_drMalDome6.R{1,2}.fq.gz`) is Sanger's Newton. What does its kmer spectrum look like?

```bash
mbMem=5000; bsub -n 20 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "/software/team301/FASTK/FastK -t20 -k21 ./sanger_newton_drMalDome6.R{1,2}.fq.gz"
```