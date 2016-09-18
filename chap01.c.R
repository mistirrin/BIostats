#extract species from psiblast output

# Method: 
#   For each line of input, check for a pattern of form [Drosophila melanogaster]
#   Use each pattern found as the index in an associative array
#   The value corresponding to this index is irrelevant
#   By using an associative array, subsequent instances of the same
#      species will overwrite the first instance, keeping only a unique set
#   After processing of input complete, sort results and print.

file <- "C:/Users/perez/Documents/MASDA/PERL/species.txt" 
lines <- readLines(file , warn = FALSE)
matches <- regexpr("\\[([A-Z][a-z]+ [a-z]+)\\]", lines) # select lines containing strings of form [Drosophila melanogaster]           
result <- regmatches(lines, matches, invert = FALSE)    # extract the matches

print(sort(result))                                     # sort the matches in alphabetical order and print

for (name in sort(result)) {                            # in alphabetical order
  print(name)                                           # print the matches
}