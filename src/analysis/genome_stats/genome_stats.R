library(data.table)

setwd("~/Documents/apple_day/src/analysis/genome_stats/")

gcs <- fread("apple_genome_gc.tsv", col.names = c("assembly", "chromosome", "gc"))
lens <- fread("apple_genome_lengths.tsv", col.names = c("assembly", "chromosome", "length"))
n50s <- fread("apple_genome_n50.tsv", col.names = c("assembly", "n50"))

# merge all these
gc_len <- gcs[lens, on = .(assembly, chromosome)]

plot(gc_len$length, gc_len$gc)

# what are all these?
gc_len[length < 100000 & gc > 0.5]
# add colours
plot_cols <- data.table(chromosome = unique(gc_len[length > 3000000]$chromosome),
                        col = c(
                          "dodgerblue2", "#E31A1C", # red
                          "green4",
                          "#6A3D9A", # purple
                          "#FF7F00", # orange
                          "black", "gold1",
                          "skyblue2", "#FB9A99", # lt pink
                          "palegreen2",
                          "#CAB2D6", # lt purple
                          "#FDBF6F", # lt orange
                          "gray70", "khaki2",
                          "maroon", "orchid1", "deeppink1", "blue1", "steelblue4",
                          "darkturquoise", "green1", "yellow4", "yellow3",
                          "darkorange4", "brown"
                        )[1:17])
# add 
gc_len_col <- gc_len[plot_cols, on = .(chromosome)]
# add symbol difference for sylvestris
gc_len_col[, pch := ifelse(grepl("Sylv", assembly), 17, 19)]

a <- seq(0, max(gc_len_col$length), by = 1000000)
a[c(FALSE, TRUE)] <- NA

png(file = "img/GC_length_all_apples.png", units = "in", width = 12, height = 8, res = 400)
plot(gc_len_col$length, 
     gc_len_col$gc, 
     col = gc_len_col$col, 
     pch = gc_len_col$pch, 
     cex = 1.8, 
     xaxt = "n", 
     bty = "n",
     ylab = "GC content",
     xlab = "Chromosome length")
axis(
  side = 1,
  at = a,
  labels = sprintf("%1.f Mb", a / 1000000)
)

# calculate the centroids for labels
#centroids <- aggregate(cbind(length, 
 #                            gc) ~ chromosome, gc_len_col, mean)

#text(x = centroids$length, y = centroids$gc, labels = centroids$chromosome)

legend(30000000, 0.388,
       legend=c("Crab-apple", "Domestic apple"), 
       col = c("grey", "grey"),
       pch=c(17, 19), 
       cex=1.2, 
       box.lty=0, 
       pt.cex = 3)
dev.off()