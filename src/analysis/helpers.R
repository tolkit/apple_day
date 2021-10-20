library(data.table)

pi_windows_plot <- function(data,
                            chromosome = "SUPER_1",
                            type = "h",
                            title = "",
                            ADD_HORIZ = TRUE,
                            ...) {
    x <- data[CHROM == chromosome]$BIN_START
    y <- pi_windows[CHROM == chromosome]$PI

    a <- seq(0, tail(data[CHROM == chromosome]$BIN_START, n = 1), by = 1000000)
    a[c(TRUE, FALSE)] <- NA

    plot(
        x = x,
        y = y,
        type = type,
        xlab = "Distance along chromosome",
        ylab = "",
        xaxt = "n",
        bty = "n",
        ...
    )

    axis(
        side = 1,
        at = a,
        labels = sprintf("%1.f Mb", a / 1000000)
    )

    if (ADD_HORIZ) {
        mean_pi <- mean(y)
        abline(h = mean_pi, col = "red", lty = 3)
    }

    title(
        main = title,
        ylab = ifelse(ADD_HORIZ,
            paste(
                "Pi (mean = ",
                sprintf("%.5f", mean_pi),
                ")"
            ),
            "Pi"
        )
    )
}