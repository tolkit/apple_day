# Notes

Getting data from SRA from the studies [[1]](#1) and [[2]](#2).

```
# latest sra-tools
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.11.1/sratoolkit.2.11.1-ubuntu64.tar.gz
tar -xvzf sratoolkit.2.11.1-ubuntu64.tar.gz

# now use prefetch (assuming it's in PATH)

# submit with NAME=sra; mbMem=5000; bsub -n 10 -q long -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.sra.out -e %J.sra.err "bash download_sra_accessions.bash"
```

These are downloading now.

## References

<a id="1">[1]</a> Sun et al., (2020) Phased diploid genome assemblies and pan-genomes provide insights into the genetic history of apple domestication. *Nature genetics* <b>52</b>(12), 1423-1432.

<a id="2">[2]</a> Duan et al., (2017) Genome re-sequencing reveals the history of apple and supports a two-stage model for fruit enlargement. *Nature Communications* <b>8</b>(1), 1-11.