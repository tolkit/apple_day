# Investigating fasta_windows output

library(data.table)

setwd("~/Documents/apple_day/src/analysis/fw/data/")
source("../../helpers.R")

for (i in list.files(".")) {
    assign(gsub(pattern = "\\.tsv", replacement = "", i), fread(i))
}

# Malus sylvestris

sylv <- drMalSylv7_windows[grepl("SUPER_[[:digit:]]*$", ID), ][, ID_sort := gsub("SUPER_", "", ID)]
sylv <- sylv[order(as.numeric(ID_sort))]

# pdf(  file = "../img/MsylvGC.pdf", width = 40, height = 4)
png(
    file = "../img/MsylvGC.png",
    units = "in",
    width = 40,
    height = 4,
    res = 400
)
layout.matrix <- matrix(seq(1:17), nrow = 1, ncol = 17)

layout(
    mat = layout.matrix,
    heights = rep(1, 17),
    widths = rep(2, 17)
)

index <- 0
for (id in unique(sylv$ID)) {
    if (index == 0) {
        par(mar = c(3, 5, 3, 0.5))
    } else {
        par(mar = c(3, 0.5, 3, 0.5))
    }

    plot_apple_variable_windows(
        data = sylv,
        roll_win = 200,
        chrom = id,
        yaxt = "n",
        ylim = summary(sylv$GC_prop)[c("Min.", "Max.")],
        ylab = "GC content",
        cex.lab = 2.5,
        xlab = "",
        title = id
    )
    if (index == 0) {
        axis(2)
    }
    index <- index + 1
}
dev.off()

# Bardsey Island Apple

bard <- drMalDome11_windows[grepl("SUPER_[[:digit:]]*$", ID), ][, ID_sort := gsub("SUPER_", "", ID)]
bard <- bard[order(as.numeric(ID_sort))]

# pdf(file = "../img/BardseyGC.pdf", width = 40, height = 4)
png(
    file = "../img/BardseyGC.png",
    units = "in",
    width = 40,
    height = 4,
    res = 400
)
layout(
    mat = layout.matrix,
    heights = rep(1, 17),
    widths = rep(2, 17)
)

index <- 0
for (id in unique(bard$ID)) {
    if (index == 0) {
        par(mar = c(3, 5, 3, 0.5))
    } else {
        par(mar = c(3, 0.5, 3, 0.5))
    }

    plot_apple_variable_windows(
        data = bard,
        roll_win = 200,
        chrom = id,
        yaxt = "n",
        ylim = summary(bard$GC_prop)[c("Min.", "Max.")],
        ylab = "GC content",
        cex.lab = 2.5,
        xlab = "",
        title = id
    )
    if (index == 0) {
        axis(2)
    }
    index <- index + 1
}
dev.off()

# Costard

cost <- drMalDome5_windows[grepl("SUPER_[[:digit:]]*$", ID), ][, ID_sort := gsub("SUPER_", "", ID)]
cost <- cost[order(as.numeric(ID_sort))]

# pdf(file = "../img/CostardGC.pdf", width = 40, height = 4)
png(
    file = "../img/CostardGC.png",
    units = "in",
    width = 40,
    height = 4,
    res = 400
)
layout(
    mat = layout.matrix,
    heights = rep(1, 17),
    widths = rep(2, 17)
)

index <- 0
for (id in unique(cost$ID)) {
    if (index == 0) {
        par(mar = c(3, 5, 3, 0.5))
    } else {
        par(mar = c(3, 0.5, 3, 0.5))
    }

    plot_apple_variable_windows(
        data = bard,
        roll_win = 200,
        chrom = id,
        yaxt = "n",
        ylim = summary(cost$GC_prop)[c("Min.", "Max.")],
        ylab = "GC content",
        cex.lab = 2.5,
        xlab = "",
        title = id
    )
    if (index == 0) {
        axis(2)
    }
    index <- index + 1
}
dev.off()



# Brown Snout

brown <- drMalDome10_windows[grepl("SUPER_[[:digit:]]*$", ID), ][, ID_sort := gsub("SUPER_", "", ID)]
brown <- brown[order(as.numeric(ID_sort))]

# pdf(file = "../img/BrownSnoutGC.pdf", width = 40, height = 4)
png(
    file = "../img/BrownSnoutGC.png",
    units = "in",
    width = 40,
    height = 4,
    res = 400
)
layout(
    mat = layout.matrix,
    heights = rep(1, 17),
    widths = rep(2, 17)
)

index <- 0
for (id in unique(brown$ID)) {
    if (index == 0) {
        par(mar = c(3, 5, 3, 0.5))
    } else {
        par(mar = c(3, 0.5, 3, 0.5))
    }

    plot_apple_variable_windows(
        data = brown,
        roll_win = 200,
        chrom = id,
        yaxt = "n",
        ylim = summary(brown$GC_prop)[c("Min.", "Max.")],
        ylab = "GC content",
        cex.lab = 2.5,
        xlab = "",
        title = id
    )
    if (index == 0) {
        axis(2)
    }
    index <- index + 1
}
dev.off()

# Flower of Kent

fok <- drMalDome58_windows[grepl("SUPER_[[:digit:]]*$", ID), ][, ID_sort := gsub("SUPER_", "", ID)]
fok <- fok[order(as.numeric(ID_sort))]

# pdf(file = "../img/FlowerOfKentGC.pdf", width = 40, height = 4)
png(
    file = "../img/FlowerOfKentGC.png",
    units = "in",
    width = 40,
    height = 4,
    res = 400
)
layout(
    mat = layout.matrix,
    heights = rep(1, 17),
    widths = rep(2, 17)
)

index <- 0
for (id in unique(fok$ID)) {
    if (index == 0) {
        par(mar = c(3, 5, 3, 0.5))
    } else {
        par(mar = c(3, 0.5, 3, 0.5))
    }

    plot_apple_variable_windows(
        data = fok,
        roll_win = 200,
        chrom = id,
        yaxt = "n",
        ylim = summary(fok$GC_prop)[c("Min.", "Max.")],
        ylab = "GC content",
        cex.lab = 2.5,
        xlab = "",
        title = id
    )
    if (index == 0) {
        axis(2)
    }
    index <- index + 1
}
dev.off()