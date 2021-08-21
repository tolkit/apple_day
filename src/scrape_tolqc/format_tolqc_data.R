#!/usr/bin/env Rscript

# Max Brown; Wellcome Sanger Institute 2021

###############
## Libraries ##
###############

library(data.table)
library(jsonlite)

##########
## Main ##
##########

# per species, load gscope, illumina & pacbio
# merge on source & specimen?
# print

apples <- c("Malus_domestica", "Malus_sylvestris", "Malus_x_robusta")

merged_list <- list()
merged_asm <- list()
list_index <- 1

for (apple in apples) {
    m_dom_fnames <- list.files("../../data/tolqc_data/",
        pattern = paste(apple, "*", sep = ""),
        full.names = TRUE
    )

    m_dom_ls <- lapply(m_dom_fnames, fread)

    names(m_dom_ls) <- gsub(
        pattern = ".txt",
        replacement = "",
        substr(m_dom_fnames, 24, 100),
        fixed = TRUE
    )

    # all merge to gscope table

    gscope <- m_dom_ls[paste(apple, "_gscope_data", sep = "")][[1]]
    illumina <- m_dom_ls[paste(apple, "_ill_data", sep = "")][[1]]
    pacbio <- m_dom_ls[paste(apple, "_pbio_data", sep = "")][[1]]
    assembly <- m_dom_ls[paste(apple, "_asm_data", sep = "")][[1]]

    # add n50 to illumina
    illumina[, n50 := 0]
    # add read_pairs to pacbio
    pacbio[, read_pairs := 0]

    seq <- rbind(illumina, pacbio)

    merged <- seq[gscope, on = .(source, specimen)]

    merged[, apple_sp := apple]

    # minor cleaning
    merged <- merged[source != "-"]

    merged_list[[list_index]] <- merged
    merged_asm[[list_index]] <- assembly

    list_index <- list_index + 1
}

all_merged <- rbindlist(merged_list)
all_merged_assembly <- rbindlist(merged_asm)

## WRTIE FILES
# sequencing stats

# table for stuff
fwrite(all_merged,
    file = "../../data/tolqc_data/all_apples_merged.tsv",
    sep = "\t"
)

# json for other stuff
write_json(
    x = all_merged,
    "../../data/tolqc_data/all_apples_merged.json"
)

# assembly stats

# table for stuff
fwrite(all_merged_assembly,
    file = "../../data/tolqc_data/all_apples_merged_asm.tsv",
    sep = "\t"
)

# json for other stuff
write_json(
    x = all_merged_assembly,
    "../../data/tolqc_data/all_apples_merged_asm.json"
)