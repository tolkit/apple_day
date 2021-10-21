library(data.table)
library(Tetmer)

setwd("~/Documents/apple_day/src/analysis/kmer/")
source("../helpers.R")

# this is from the three ccs pacbio files in one.
png(filename = "./img/drMalDome58_kmer_spectrum.png", width = 8,
    height = 6,
    units = "in", 
    res = 400)
par(mar = c(5, 5, 4, 2))
read_plot_fastk_histex("./data/drMalDome58_m64016e_210808_072016.filtered_hist.txt")
dev.off()

# we should also do the illumina data

png(filename = "./img/sangers_newton_illumina.png", width = 8,
    height = 6,
    units = "in", 
    res = 400)
par(mar = c(5, 5, 4, 2))
read_plot_fastk_histex("./data/sanger_newton_drMalDome6.R1.txt", range = 2:200, ylim=c(0, 8000000))
dev.off()

sanger_newton_ill_spec <- read_plot_fastk_histex("./data/sanger_newton_drMalDome6.R1.txt", RETURN = TRUE)

fwrite(x = sanger_newton_ill_spec[, .(index, count)], 
       file = "./data/sanger_newton_drMalDome6.R1_spectrum.txt", 
       sep = "\t", col.names = FALSE)

## tetmer
#install.packages("./Tetmer_2.0.0.tar.gz", repo=NULL)

# analyse with tetmer
spec <- Tetmer::read.spectrum(f = "./data/sanger_newton_drMalDome6.R1_spectrum.txt")
tetmer(spec)
# try autotriploid with 
# kmer multiplicity 44
# peak width 0.4
# theta 0.32
# haploid genome size 