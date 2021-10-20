library(pafr)
library(ggplot2)
library(stringr)

setwd("~/Documents/apple_day/src/analysis/minimap2/")

# ref is domestica
#ali <- read_paf("./5_syl_m_domestica_sylvestris.paf")
#ali2 <- read_paf("./5_11_m_domestica.paf")

# our Costard vs the current reference genome
ali <- read_paf("./data/5_GD_m_domestica.paf")

chrom_map <- readLines(textConnection(object = ">NC_041798.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 10, ASM211411v1, whole genome shotgun sequence
>NC_041799.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 11, ASM211411v1, whole genome shotgun sequence
>NC_041800.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 12, ASM211411v1, whole genome shotgun sequence
>NC_041801.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 13, ASM211411v1, whole genome shotgun sequence
>NC_041802.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 14, ASM211411v1, whole genome shotgun sequence
>NC_041803.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 15, ASM211411v1, whole genome shotgun sequence
>NC_041804.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 16, ASM211411v1, whole genome shotgun sequence
>NC_041805.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 17, ASM211411v1, whole genome shotgun sequence
>NC_041789.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 1, ASM211411v1, whole genome shotgun sequence
>NC_041790.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 2, ASM211411v1, whole genome shotgun sequence
>NC_041791.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 3, ASM211411v1, whole genome shotgun sequence
>NC_041792.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 4, ASM211411v1, whole genome shotgun sequence
>NC_041793.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 5, ASM211411v1, whole genome shotgun sequence
>NC_041794.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 6, ASM211411v1, whole genome shotgun sequence
>NC_041795.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 7, ASM211411v1, whole genome shotgun sequence
>NC_041796.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 8, ASM211411v1, whole genome shotgun sequence
>NC_041797.1 Malus domestica cultivar Golden Delicious isolate X9273 #13 chromosome 9, ASM211411v1, whole genome shotgun sequence
>NC_018554.1 Malus x domestica mitochondrion, complete genome"))

ali$qname <- c("mito", paste0("chr", 1:17))[as.factor(ali$qname)]

#ali$qname <- paste0("Q", ali$qname)
#ali$tname <- paste0("T", ali$tname)

#ali2$qname <- paste0("Q", ali2$qname)
#ali2$tname <- paste0("T", ali2$tname)

prim_alignment <- filter_secondary_alignments(ali)

costard_vs_gd <- dotplot(prim_alignment, label_seqs = TRUE, 
        ordering = list(paste0("chr", 1:17),
                        paste0("SUPER_", 1:17)), 
        order_by = "provided", 
        xlab = "Golden Delicious", 
        ylab = "DToL Costard") + theme_bw()

ggsave(filename = "./img/costard_vs_gc.png", 
       plot = costard_vs_gd, 
       device = "png", 
       width = 10, 
       height = 10, 
       units = "in")

prim_alignment$perid <- prim_alignment$nmatch / prim_alignment$alen
colorfunc <- colorRamp(c("orange","black"))

# Use colorfunc to create colors that range from blue to white to red 
# across the range of x
prim_alignment$COLOUR <- rgb(colorfunc(prim_alignment$perid), maxColorValue=255)

# inversion between our genome and 'golden delicious'
for(i in c(1, 2, 6, 10)) {
        tmp <- prim_alignment[prim_alignment$qname == paste0("chr", i) & prim_alignment$tname == paste0("SUPER_", i), ]
        tmp_dotplot <- my_dotplot(tmp, 
                   label_seqs = TRUE, 
                   xlab = "Golden Delicious", 
                   ylab = "DToL Costard", 
                   alignment_colour1 = tmp[tmp$strand == "+",]$COLOUR,
                   alignment_colour2 = tmp[tmp$strand == "-",]$COLOUR, line_size = 8) + theme_bw() +
                theme(axis.text=element_text(size=12),
                      axis.title=element_text(size=20,
                                              face="bold")) + geom_abline(slope = 1, 
                                                                          intercept = 0, 
                                                                          colour = "red",
                                                                          linetype = "dashed")
        ggsave(filename = paste0("img/", paste0("chr", i), ".png"), 
               plot = tmp_dotplot, 
               device = "png", 
               units = "in", 
               width = 10, 
               height = 10)
}


#prim_alignment2 <- filter_secondary_alignments(ali2)

#SUPERS <- prim_alignment[prim_alignment$qname %in% paste0("QSUPER_", 1:17), ]
#SUPERS2 <- prim_alignment2[prim_alignment2$qname %in% paste0("QSUPER_", 1:17), ]

q_chroms <- unique(prim_alignment$qname)[1:17]
t_chroms <- unique(prim_alignment$tname)[
        order(unique(prim_alignment$tname))
][-c(1:2)]

dotplot(SUPERS2,
        label_seqs = TRUE, order_by = "provided",
        ordering = list(
                paste0("QSUPER_", 1),
                paste0("TSUPER_", 1)
        )
) + theme_bw()
dotplot(SUPERS2[SUPERS2$tname == "TSUPER_3", ], label_seqs = TRUE)

plot_synteny(
        ali = prim_alignment2,
        q_chrom = "QSUPER_1", t_chrom = "TSUPER_1", centre = TRUE
)

plot_coverage(prim_alignment2[prim_alignment2$qname == "QSUPER_1", ], fill = "tname", target = FALSE)