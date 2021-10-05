# input the SNP data and the sample names
library(data.table)
library(adegenet)
library(vcfR)
library(ggplot2)
library(poppr)
library(ape)

setwd("~/Documents/apple_day/src/analysis/variants/")

vcf <- read.vcfR("./no_missing_merged.recode.vcf", verbose = FALSE)
# polyploid calls removed here
x <- vcfR2genlight(vcf)

pca <- glPca(x, nf = 10)

# make a new data table
pca2 <- data.table(
    id = rownames(pca$scores),
    PC1 = pca$scores[, 1],
    PC2 = pca$scores[, 2]
)

# sort out ID
pca2[, id := gsub(pattern = "\\.\\./bams/", "", id)]
pca2[, id := gsub(pattern = "\\.sorted\\.bam", "", id)]

keys <- fread("../../../data/apple_metadata/apple_key.tsv")

pca3 <- keys[pca2, on = .(ssid = id)]

pca_by_species <- ggplot(pca3, aes(x = PC1, y = PC2)) +
    geom_point(aes(colour = species))
ggsave(
    plot = pca_by_species,
    filename = "./img/pca_by_species.pdf", device = "pdf"
)

# this takes a few minutes
tree <- poppr::aboot(x = x, sample = 300, showtree = F, cutoff = 50)
# tip label wrangling
tip1 <- gsub("../bams/", "", tree$tip.label)
tip2 <- gsub(".sorted.bam", "", tip1)
TIPS <- pca3[, .(ssid, cultivar)][order(tip2)]$cultivar
# Malus sylvestris have no names for some reason
TIPS[TIPS == ""] <- "Malus sylvestris"

pdf(file = "./img/aboot_apple_tree.pdf", height = 10)
ape::plot.phylo(tree, show.tip.label = FALSE, x.lim = 0.2)
tiplabels(text = TIPS, frame = "none", adj = -0.1)
dev.off()