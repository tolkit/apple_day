# nucmer

Doing some quick nucmers to see what's what.

`run_nucmer.bash`

```bash
echo "Running nucmer. 10 vs 11."

/software/team301/MUMmer3.23/nucmer /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome10.1/drMalDome10_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa \
-p 10_11_nucmer

echo "10 vs 11 done. Doing 11 vs 5."

/software/team301/MUMmer3.23/nucmer /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome11.1/drMalDome11_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
-p 11_5_nucmer

echo "11 vs 5 done. Doing 5 vs 58."

/software/team301/MUMmer3.23/nucmer /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome58.1/drMalDome58_1.curated_primary.fa \
-p 5_58_nucmer

echo "5 vs 58 done. Doing 5 vs MalSylv."

/software/team301/MUMmer3.23/nucmer /lustre/scratch116/tol/projects/darwin/data/dicots/Malus_domestica/assembly/curated/drMalDome5.1/drMalDome5_1.curated_primary.fa \
/lustre/scratch116/tol/projects/darwin/data/dicots/Malus_sylvestris/assembly/curated/drMalSylv7.1/drMalSylv7_1.curated_primary.fa \
-p 5_MalSylv_nucmer

echo "Done."
```

Submitted with:

```bash
chmod +x run_nucmer.bash

mbMem=5000; bsub -n 10 -q normal -R"span[hosts=1] select[mem>${mbMem}] rusage[mem=${mbMem}]" -M${mbMem} -o %J.out -e %J.err "bash run_nucmer.bash"
```

Note that `nucmer.pl` was hand edited according to this website https://lufuhao.wordpress.com/2017/09/13/mummerplot-running-errors-and-solutions/.