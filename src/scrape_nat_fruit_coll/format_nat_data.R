library(data.table)

nat <- fread("./nat_data.txt", sep = NULL, header = FALSE)
nat <- nat[V1 != ""]

nat[, V1 := as.factor(V1)]
# which lines contain new record, as we split on that
indexes <- which(nat$V1 %in% "NEXT RECORD")
# length(indexes) == 2000 :)

# the lengths of each of the records
xxx <- indexes - c(0, indexes)
xxx <- xxx[-length(xxx)]
# add these to the data table
nat[, factor := as.factor(c(rep(1:length(xxx), xxx)))]
# split on the factor to isolate each record in a list
nat <- split(nat, nat$factor)
# change the resulting data back to character vector, otherwise there's over a million factor levels
splitNat <- lapply(nat, function(x) as.character(x$V1))

get_index <- function(regex = "", test) {
  index <- ifelse(
    grep(regex, test) == 0, 
    NULL, 
    grep(regex, test) + 1 # or its the next index
  )
  return(index)
}

# parsing will require a bit of thought
splitNatDat <- lapply(splitNat, function(test){
  # get indexes
  description <- get_index("^Malus domestica Borkh\\.", test)
  #synonyms
  synonyms <- get_index("^Synonyms:", test)
  #availability
  availability <- get_index("^Availability", test)
  #shape
  shape <- get_index("^Shape", test)
  #size
  size <- get_index("^Size", test)
  #height
  height <- get_index("^Height", test)
  #width
  width <- get_index("^Width", test)
  #ribbing
  ribbing <- get_index("^Ribbing", test)
  #ground colour
  ground_colour <- get_index("^Ground Colour", test)
  #over colour
  over_colour <- get_index("^Over Colour$", test)
  #over colour (pattern)
  over_colour_p <- get_index("^Over Colour \\(Pattern\\)", test)
  #crunch
  crunch <- get_index("^Crunch", test)
  #flesh colour
  flesh_colour <- get_index("^Flesh Colour", test)
  #accession name
  accession_name <- get_index("^Accession name", test)
  #flowering time
  flowering <- get_index("^Flowering time", test)
  if(!is.logical(flowering)) {
    flowering <- c(flowering, flowering +1, flowering +2)
  }
  #picking time
  picking <- get_index("^Picking time", test)
  # more
  russet <- get_index("^Russet$", test)
  crown <- get_index("^Crown$", test)
  coarseness <- get_index("^Coarseness$", test)
  
  data.table(
    Accession_Name = test[accession_name],
    Description = test[description],
    Synonyms = test[synonyms],
    Availability = test[availability],
    Shape = gsub("[[:space:]][[:digit:]]", "", test[shape]),
    Size = gsub("[[:space:]][[:digit:]]", "", test[size]),
    Height = gsub("[[:space:]]mm[[:space:]][[:digit:]]|mm[[:space:]][[:digit:]]", "", test[height]),
    Width = gsub("[[:space:]]mm[[:space:]][[:digit:]]|mm[[:space:]][[:digit:]]", "", test[width]),
    Ribbing = gsub("[[:space:]][[:digit:]]", "", test[ribbing]),
    Ground_Colour= gsub("[[:space:]][[:digit:]]", "", test[ground_colour]),
    Over_Colour= gsub("[[:space:]][[:digit:]]", "", test[over_colour]),
    Over_Colour_P = gsub("[[:space:]][[:digit:]]", "", test[over_colour_p]),
    Crunch = gsub("[[:space:]][[:digit:]]", "", test[crunch]),
    Flesh_Colour = gsub("[[:space:]][[:digit:]]", "", test[flesh_colour]),
    Flowering = paste(test[flowering], collapse = ", "),
    Picking = gsub("[[:space:]][[:digit:]]", "", test[picking]),
    Russet = gsub("[[:space:]][[:digit:]]", "", test[russet]),
    Crown = gsub("[[:space:]][[:digit:]]", "", test[crown]),
    Coarseness = gsub("[[:space:]][[:digit:]]", "", test[coarseness])
  )
  
})

# all data
NatDat <- rbindlist(splitNatDat)

fwrite(x = NatDat, file = "../../data/apple_metadata/national_fruit_coll_apple.tsv", sep = "\t")

# data for cultivars we have sequenced
NatDatSeq <- NatDat[grepl(pattern = "Blenheim Orange \\(LA 62A\\)Worcester Pearmain \\(LA\\)|Kingston Black|^Harvey$|^Ashmead's Kernel|Decio|Fiesta|Park Farm Pippin|Lord Burghley|Irish Peach|Cox's Orange Pippin \\(LA\\)|Scotch Dumpling|Hood's Supreme|Cutler Grieve|Stobo Castle|Beauty of Moray|East Lothian Pippin|Tower of Glamis|Scotch Bridget|Stirling Castle|Oslin|^Hawthornden|Red Devil|Scrumptious|Red Falstaff|^Falstaff$|Bountiful|Ellison's Orange \\(McCarroll\\)|Bardsey|Early Julyan|Bloody Ploughman|Alderman|Lass|Port Allen Russet|Bramley|Egremont|^Pixie|Discovery \\(original tree No\\. 1\\)|James Grieve \\(LA\\)|Laxton's Superb \\(EMLA 1\\)|^Newton Wonder", NatDat$Accession_Name)]

fwrite(x = NatDatSeq, file = "../../data/apple_metadata/national_fruit_coll_apple_seq.tsv", sep = "\t")