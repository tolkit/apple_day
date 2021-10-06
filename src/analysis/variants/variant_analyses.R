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

# pi windows

pi_windows <- fread("./no_missing_merged_windows.windowed.pi")

pi_windows_plot <- function(data,
                            chromosome = "SUPER_1",
                            type = "h",
                            title = "",
                            ADD_HORIZ = TRUE) {
    x <- data[CHROM == chromosome]$BIN_START
    y <- pi_windows[CHROM == chromosome]$PI
    
    a <- seq(0, tail(data[CHROM == chromosome]$BIN_START, n = 1), by = 1000000)
    a[c(TRUE, FALSE)] <- NA
    
    plot(x = x, 
         y = y, 
         type = type, 
         xlab = "Distance along chromosome",
         ylab = "",
         xaxt = "n",
         bty = "n")
    
    axis(side = 1,
         at = a,
         labels = sprintf("%1.f Mb", a / 1000000)
    )
    
    if(ADD_HORIZ) {
        mean_pi <- mean(y)
        abline(h = mean_pi, col = "red", lty = 3)
    }
    
    title(main = title, 
          ylab = ifelse(ADD_HORIZ,
                        paste("Pi (mean = ", 
                              sprintf("%.5f", mean_pi), 
                              ")"),
                        "Pi")
          )
}

chroms <- pi_windows[, .(unique(CHROM))]$V1

pdf(file = "./img/pi_all_chroms.pdf", height = 12)
par(mfrow=c(length(chroms) / 2,
            2))
for (chrom in chroms) {
    par(mar=c(2,5,1,5))
    pi_windows_plot(pi_windows, title = chrom, chromosome = chrom)
}
dev.off()

