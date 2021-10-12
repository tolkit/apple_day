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
                        col = rainbow(17))
# add 
gc_len_col <- gc_len[plot_cols, on = .(chromosome)]
# add symbol difference for sylvestris
gc_len_col[, pch := ifelse(grepl("Sylv", assembly), 17, 19)]

a <- seq(0, max(gc_len_col$length), by = 1000000)
a[c(FALSE, TRUE)] <- NA

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
