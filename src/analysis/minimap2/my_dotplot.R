# editing the dotplot function, so I can colour the segments by percent identity
# pretty hacky but works.
# if `ali` is a pafR alignment object:
# ali$perid <- ali$nmatch / ali$alen
# then make a colour function
# colorfunc <- colorRamp(c("orange","black"))
# ali$COLOUR <- rgb(colorfunc(ali$perid), maxColorValue=255)
# in the dotplot function:
# test <- ali[ali$qname == "chr6" & ali$tname == "SUPER_6", ]
# my_dotplot(test, 
#           label_seqs = TRUE, 
#           xlab = "Golden Delicious", 
#           ylab = "DToL Costard", 
#           alignment_colour1 = test[test$strand == "+",]$COLOUR,
#           alignment_colour2 = test[test$strand == "-",]$COLOUR, line_size = 8) + theme_bw() 

my_dotplot <- function (ali, order_by = c("size", "qstart", "provided"), label_seqs = FALSE, 
                        dashes = TRUE, ordering = list(), alignment_colour1 = "black", 
                        alignment_colour2 = "black", 
                        xlab = "query", ylab = "target", line_size = 2) 
{
  by <- match.arg(order_by)
  if (by == "provided") {
    check_ordering(ali, ordering)
    ali <- ali[ali$qname %in% ordering[[1]] & ali$tname %in% 
                 ordering[[2]], ]
  }
  seq_maps <- order_seqs(ali, by, ordering)
  ali <- add_pos_in_concatentaed_genome(ali, seq_maps)
  p <- ggplot() + geom_segment(data = ali[ali$strand == "+", 
  ], aes_string(x = "concat_qstart", xend = "concat_qend", 
                y = "concat_tstart", yend = "concat_tend"), size = line_size, 
  colour = alignment_colour1) + geom_segment(data = ali[ali$strand == 
                                                         "-", ], aes_string(x = "concat_qend", xend = "concat_qstart", 
                                                                            y = "concat_tstart", yend = "concat_tend"), size = line_size, 
                                            colour = alignment_colour2) + coord_equal() + scale_x_continuous(xlab, 
                                                                                                            labels = Mb_lab) + scale_y_continuous(ylab, labels = Mb_lab)
  if (dashes) {
    p <- p + geom_hline(yintercept = c(seq_maps[["tmap"]], 
                                       sum(unique(ali$tlen))), linetype = 3) + geom_vline(xintercept = c(seq_maps[["qmap"]], 
                                                                                                         sum(unique(ali$qlen))), linetype = 3)
  }
  if (label_seqs) {
    qname_df <- dotplot_name_df(seq_maps[["qmap"]], seq_maps[["qsum"]])
    tname_df <- dotplot_name_df(seq_maps[["tmap"]], seq_maps[["tsum"]])
    p <- p + geom_text(data = qname_df, aes_string(label = "seq_name", 
                                                   x = "centre", y = "0"), vjust = 1, check_overlap = TRUE) + 
      geom_text(data = tname_df, aes_string(label = "seq_name", 
                                            x = "0", y = "centre"), angle = 90, vjust = 0, 
                check_overlap = TRUE)
  }
  p$seq_map_fxn <- function(bed, query = TRUE, ...) {
    map_n <- if (query) 
      1
    else 3
    seq_map <- seq_maps[[map_n]]
    check_chroms <- bed[["chrom"]] %in% names(seq_map)
    if (!(all(check_chroms))) {
      if (!(any(check_chroms))) {
        stop("None of the chromosomes represented this bed file are part of the dotplot")
      }
      else {
        bed <- bed[bed$chrom %in% names(seq_map), ]
        missing <- unique(bed[["chrom"]][!check_chroms])
        msg <- paste(length(missing), "of the chromosomes in this bed file are not part of the dotplot:\n  ", 
                     paste(missing, collapse = ", "))
        warning(msg, call. = FALSE)
      }
    }
    data.frame(istart = bed[["start"]] + seq_map[bed[["chrom"]]], 
               iend = bed[["end"]] + seq_map[bed[["chrom"]]], len = seq_maps[[map_n + 
                                                                                1]])
  }
  p
}
order_seqs <- function(ali, by, ordering = list()) {
  chrom_lens <- chrom_sizes(ali)
  qsum <- sum(chrom_lens[["qlens"]][, 2])
  tsum <- sum(chrom_lens[["tlens"]][, 2])
  if (by == "size") {
    q_idx <- order(chrom_lens[["qlens"]][, 2], decreasing = TRUE)
    t_idx <- order(chrom_lens[["tlens"]][, 2], decreasing = TRUE)
    qmap  <- structure(.Names = chrom_lens[["qlens"]][q_idx, 1],
                       c(0, head(cumsum(chrom_lens[["qlens"]][q_idx, 2]), -1)))
    tmap  <- structure(.Names = chrom_lens[["tlens"]][t_idx, 1],
                       c(0, head(cumsum(chrom_lens[["tlens"]][t_idx, 2]), -1)))
  } else if (by == "qstart") {
    #TODO
    #qidx/map id duplicated from above. DRY out depending on how we
    #implement other options
    q_idx <- order(chrom_lens[["qlens"]][, 2], decreasing = TRUE)
    qmap  <- structure(.Names = chrom_lens[["qlens"]][q_idx, 1],
                       c(0, head(cumsum(chrom_lens[["qlens"]][q_idx, 2]), -1)))
    longest_by_target <- slice_max(group_by(ali, .data[["tname"]]), .data[["alen"]])
    t_idx <- order(qmap[longest_by_target$qname] + longest_by_target$qstart)
    tmap <- sort(structure(.Names = longest_by_target$tname[t_idx],
                           c(0, head(cumsum(longest_by_target$tlen[t_idx]), -1))))        
  } else if (by == "provided") {
    if (length(ordering) != 2) {
      stop("To use 'provided' sequence ordering argument 'ordering' must by a list with two character vectors")
    }
    qord <- ordering[[1]]
    tord <- ordering[[2]]
    q_idx <- match(qord, chrom_lens[["qlens"]][["qname"]])
    if (any(is.na(q_idx))) {
      msg <- paste("Sequence(s) provided for ordering are not present in alignment:\n", qord[is.na(q_idx)], "\n")
      stop(msg)
    }
    t_idx <- match(tord, chrom_lens[["tlens"]][["tname"]])
    if (any(is.na(t_idx))) {
      msg <- paste("Sequence(s) provided for ordering are not present in alignment:\n", tord[is.na(t_idx)], "\n")
      stop(msg)
    }
    qmap <- structure(.Names = chrom_lens[["qlens"]][q_idx, 1],
                      c(0, head(cumsum(chrom_lens[["qlens"]][q_idx, 2]), -1)))
    tmap <- structure(.Names = chrom_lens[["tlens"]][t_idx, 1],
                      c(0, head(cumsum(chrom_lens[["tlens"]][t_idx, 2]), -1)))
  }
  list(qmap = qmap, qsum = qsum, tmap = tmap, tsum = tsum)
}


add_pos_in_concatentaed_genome <- function(ali, maps) {
  ali$concat_qstart <- ali$qstart + maps[["qmap"]][ali$qname]
  ali$concat_qend <- ali$qend + maps[["qmap"]][ali$qname]
  ali$concat_tstart <- ali$tstart + maps[["tmap"]][ali$tname]
  ali$concat_tend <- ali$tend + maps[["tmap"]][ali$tname]
  ali
}


dotplot_name_df <- function(seq_map, genome_len) {
  data.frame(seq_name = names(seq_map),
             centre = seq_map + diff(c(seq_map, genome_len) / 2))
}


check_ordering <- function(ali, ordering) {
  q_in_order <- unique(ali[["qname"]]) %in% ordering[[1]]
  t_in_order <- unique(ali[["tname"]]) %in% ordering[[2]]
  if (any(!q_in_order)) {
    msg <- paste("Dropping data from sequences absent from ordering:\n",
                 paste(unique(ali[["qname"]])[!q_in_order], collapse = ","))
    warning(msg, call. = FALSE)
  }
  if (any(!t_in_order)) {
    msg <- paste("Dropping data from sequences absent from ordering:\n",
                 paste(unique(ali[["tname"]])[!t_in_order], collapse = ","))
    warning(msg, call. = FALSE)
  }
  return(invisible())
}

