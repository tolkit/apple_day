library(data.table)

setwd("~/Documents/apple_day/src/analysis/kmer/")

read_plot_fastk_histex <- function(path, range = 2:100) {
  spectrum <- fread(path, skip = 7, col.names = c("index", "count", "cumulative_per"))
  
  spectrum[, index := as.numeric(gsub(":", "", index))]
  
  spectrum <- spectrum[order(index)]
  
  plot(spectrum$index[range], 
       spectrum$count[range], 
       type = "l", 
       bty = "n",
       xlab = "Kmer frequency",
       ylab = "Frequency of Kmer frequency",
       cex.lab = 2)
}

png(filename = "./img/drMalDome58_kmer_spectrum.png", width = 8,
    height = 6,
    units = "in", 
    res = 400)
par(mar = c(5, 5, 4, 2))
read_plot_fastk_histex("./data/drMalDome58_m64016e_210808_072016.filtered_hist.txt")
dev.off()

## tetmer
install.packages("./Tetmer_2.0.0.tar.gz", repo=NULL)
library(Tetmer)

spec <- Tetmer::read.spectrum(f = "drMalDome58_m64016e_210808_072016.filtered_hist copy.txt")
plot(spec)