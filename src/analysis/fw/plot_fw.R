# Investigating fasta_windows output


library(data.table)

setwd("~/Documents/apple_day/src/analysis/fw/data/")

for (i in list.files(".")) {
    assign(i, fread(i))
}

plot_apple_variable_windows <- function(data,
                                        chrom = "SUPER_1",
                                        var = "GC_prop",
                                        roll_win = 300,
                                        title = "") {
    plot(data[ID == chrom]$start,
        data[ID == chrom, get(var)],
        pch = 16,
        col = rgb(red = 0, green = 0, blue = 0, alpha = 0.1),
        xlab = "Window",
        ylab = "GC Proportion", xaxt = "n", bty = "n"
    )

    data[, roll_GC := frollmean(x = data[, GC_prop], n = roll_win)]

    a <- seq(0, tail(data[ID == chrom]$start, n = 1), by = 1000000)

    axis(1,
        at = a,
        labels = sprintf("%1.f Mb", a / 1000000)
    )
    lines(
        x = data[ID == chrom]$start,
        y = data[ID == chrom]$roll_GC,
        col = "red"
    )
    title(main = title)
}

par(mfrow = c(3, 2))
plot_apple_variable_windows(
    data = drMalSylv7_windows.tsv,
    title = "Crab-apple",
    roll_win = 200
)
plot_apple_variable_windows(
    data = drMalDome10_windows.tsv,
    title = "Brown Snout",
    roll_win = 200
)
plot_apple_variable_windows(
    data = drMalDome11_windows.tsv,
    title = "Bardsey Island Apple",
    roll_win = 200
)
plot_apple_variable_windows(
    data = drMalDome5_windows.tsv,
    title = "Costard",
    roll_win = 200
)
plot_apple_variable_windows(
    data = drMalDome58_windows.tsv,
    title = "Flower of Kent",
    roll_win = 200
)

# per chromosome analysis

per_chrom <- function(data, variable="GC_prop") {
    
}

drMalDome10_windows.tsv[, .(mean_GC_prop = mean(GC_prop)), by=.(ID)]
