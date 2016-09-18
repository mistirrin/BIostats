#assemble.R -- assemble overlapping fragments of strings
input <- readLines("C:/Users/perez/Documents/Mist Documentos/Programming/R/BIOSTATS/lines.txt", warn = FALSE)
fragments <- input

#  input of fragments
#fragments <- unlist(strsplit(input, split = "\n"))    # split input into lines
#fragments <- trimws(fragments, which = "both")        # trim trailing and leading space
#fragments <- gsub(pattern = "\\\\n$", replacement = "", x = fragments)
#  now vector  fragments  contains fragments

#  we need two relationships between fragments:
#  (1) which fragment shares no prefix with suffix of another fragment
#      * This tells us which fragment comes first
#  (2) which fragment shares longest suffix with a prefix of another
#      * This tells us which fragment  follows  any fragment

#  First set array of prefixes to the default value   "noprefixfound".
#      Later, change this default value when a prefix is found.
#      The one fragment that retains the default value must be come first.

#  Then loop over pairs of fragments to determine maximal overlap.
#      This determines successor of each fragment
#      Note in passing that if a fragment has a successor then the
#          successor must have a prefix

prefix <- rep("noprefixfound", length(fragments))     #   initially set  prefix of each fragment to  "noprefixfound" this will be overwritten when a prefix is found
names(prefix) <- fragments
successor <- character(length(fragments))
names(successor) <- fragments
#  for each pair, find longest overlap of suffix of one with prefix of the other
#       This tells us which fragment FOLLOWS any fragment

for (i in fragments) {                                #   loop over fragments
  longestsuffix <- ""                                  #   initialize longest suffix to null
  
  for (j in fragments) {                              #   loop over fragment pairs
    if (i != j) {                                     #   don't check fragment against itself
      combine <- paste0(i, "XXX", j)                   #   concatenate fragments, with fence XXX
      pattern <- "([\\S ]{2,})XXX\\1"
      #match <- gsub(pattern = pattern, replacement = "\\1", x = combine, perl = TRUE) # check for repeated sequences
      match <- regmatches(combine, gregexpr(pattern, combine, perl = TRUE))[[1]]
      if (length(match) > 0) {
        match <- substr(match, 1, (nchar(match)-3)/2)
        if (nchar(match) > nchar(longestsuffix)) {  # keep longest overlap
          longestsuffix <- match;     #   retain longest suffix
          successor[i] <- j;     #   record that $j follows $i
        }
      }
      print(paste(i,j,successor, sep="--"))
    }
  }
  prefix[successor[i]] <- "found";   #  if $j follows $i then $j must have a prefix
}

outstring <- ""

for (fragment in fragments) {                   #  find fragment that has no prefix; that's the start
  if (prefix[fragment] == "noprefixfound") { outstring <- fragment;}
}

test <- outstring;                      #   start with fragment without prefix
while (successor[test] != "") {              #   append fragments in order
  test <- successor[test];          #   choose next fragment
  outstring <- paste0(outstring, "XXX", test)  # append to string
  #outstring =~ s/([\S ]+)XXX\1/\1/;  #   remove overlapping segment
  pattern <- "([\\S ]+)XXX\\1"
  #m <- regmatches(combine, gregexpr(pattern, combine, perl = TRUE))[[1]]
  outstring <- gsub(pattern, replacement = "\\1", x = outstring, perl = TRUE)
}

print(outstring)