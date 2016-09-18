#translate.R -- translate nucleic acid sequence to protein sequence
#                according to standard genetic code

#   set up named vector of standard genetic code
sGC <- c("ttt"= "Phe",   "tct"= "Ser", "tat"= "Tyr",   "tgt"= "Cys",
            "ttc"= "Phe",   "tcc"= "Ser", "tac"= "Tyr",   "tgc"= "Cys",
            "tta"= "Leu",   "tca"= "Ser", "taa"= "TER",   "tga"= "TER",
            "ttg"= "Leu",   "tcg"= "Ser", "tag"= "TER",   "tgg"= "Trp",
            "ctt"= "Leu",   "cct"= "Pro", "cat"= "His",   "cgt"= "Arg",
            "ctc"= "Leu",   "ccc"= "Pro", "cac"= "His",   "cgc"= "Arg",
            "cta"= "Leu",   "cca"= "Pro", "caa"= "Gln",   "cga"= "Arg",
            "ctg"= "Leu",   "ccg"= "Pro", "cag"= "Gln",   "cgg"= "Arg",
            "att"= "Ile",   "act"= "Thr", "aat"= "Asn",   "agt"= "Ser",
            "atc"= "Ile",   "acc"= "Thr", "aac"= "Asn",   "agc"= "Ser",
            "ata"= "Ile",   "aca"= "Thr", "aaa"= "Lys",   "aga"= "Arg",
            "atg"= "Met",   "acg"= "Thr", "aag"= "Lys",   "agg"= "Arg",
            "gtt"= "Val",   "gct"= "Ala", "gat"= "Asp",   "ggt"= "Gly",
            "gtc"= "Val",   "gcc"= "Ala", "gac"= "Asp",   "ggc"= "Gly",
            "gta"= "Val",   "gca"= "Ala", "gaa"= "Glu",   "gga"= "Gly",
            "gtg"= "Val",   "gcg"= "Ala", "gag"= "Glu",   "ggg"= "Gly")

input <- "atgcatccctttaat    \ntctgtctga"

#   process input data
sequences <- unlist(strsplit(input, split = "\n"))              # split input into lines

for (sequence in sequences) {                                   # for each line
  sequence <- trimws(sequence, which = "both")                  # trim trailing and leading space
  print(sequence)                                               # transcribe to output
  
  triplets <- sapply(
    seq(from=1, to=nchar(sequence)-nchar(sequence)%%3, by=3),
    function(i) substr(sequence, i, i+2)
  )                                                             # pull out successive triplets
  
  aa = ""                                                       # initialize result
  for (triplet in triplets) {                                   # loop over triplets
    aa = paste0(aa, sGC[triplet])                               # concatenate translations
  }                                                             # end loop on triplets
  print(aa)                                                     # print out result
  print()                                                       # skip line on output
}                                                               # end loop on input lines
