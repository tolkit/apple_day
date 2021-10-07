library(pafr)
library(ggplot2)

setwd("~/Documents/apple_day/src/analysis/nucmer/")

# ref is domestica
ali <- read_paf("./5_syl_m_domestica_sylvestris.paf")
ali2 <- read_paf("./5_11_m_domestica.paf")

ali$qname <- paste0("Q", ali$qname)
ali$tname <- paste0("T", ali$tname)

ali2$qname <- paste0("Q", ali2$qname)
ali2$tname <- paste0("T", ali2$tname)

prim_alignment <- filter_secondary_alignments(ali)
prim_alignment2 <- filter_secondary_alignments(ali2)

SUPERS <- prim_alignment[prim_alignment$qname %in% paste0("QSUPER_", 1:17), ]
SUPERS2 <- prim_alignment2[prim_alignment2$qname %in% paste0("QSUPER_", 1:17), ]

q_chroms <- unique(prim_alignment$qname)[1:17]
t_chroms <- unique(prim_alignment$tname)[
        order(unique(prim_alignment$tname))
][-c(1:2)]

dotplot(SUPERS2,
        label_seqs = TRUE, order_by = "provided",
        ordering = list(
                q_chroms,
                t_chroms
        )
) + theme_bw()
dotplot(SUPERS2[SUPERS2$tname == "TSUPER_3", ], label_seqs = TRUE)

plot_synteny(
        ali = prim_alignment2,
        q_chrom = "QSUPER_6", t_chrom = "TSUPER_6", centre = TRUE
)

plot_coverage(prim_alignment2, fill = "tname", target = FALSE)