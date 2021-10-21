library(data.table)

setwd("~/Documents/apple_day/src/analysis/structural_variants/")

source("../helpers.R")

pi_windows <- fread("./data/drMalDome5_windows_filtered_no_missing.windowed.pi")

chroms <- pi_windows[, .(unique(CHROM))]$V1

chroms <- chroms[chroms != "scaffold_20"]

pdf(file = "./img/pi_all_chroms_drMalDome5.pdf", height = 12)
par(mfrow = c(
    (length(chroms) / 2) + 1,
    2
))
for (chrom in chroms) {
    par(mar = c(2, 5, 1, 5))
    pi_windows_plot(pi_windows,
        title = chrom,
        chromosome = chrom,
        ylim = c(
            summary(pi_windows$PI)["Min."],
            summary(pi_windows$PI)["Max."]
        )
    )
}
dev.off()