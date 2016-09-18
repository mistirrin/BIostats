#!/usr/bin/perl
#extract species from psiblast output

# Method: 
#   For each line of input, check for a pattern of form [Drosophila melanogaster]
#   Use each pattern found as the index in an associative array
#   The value corresponding to this index is irrelevant
#   By using an associative array, subsequent instances of the same
#      species will overwrite the first instance, keeping only a unique set
#   After processing of input complete, sort results and print.


while (<DATA>) {                             # read line of input
    if (/\[([A-Z][a-z]+ [a-z]+)\]/) {    # select lines containing strings of form
                                         #     [Drosophila melanogaster]                        
     $species{$1} = 1;                   # make or overwrite entry in
   }                                     #         associative array 
}

foreach (sort(keys(%species))){          # in alphabetical order,
    print "$_\n";                        #    print species names
}

__END__
of form [Drosophila melanogaster]
of form [Drosophila melanogaster]
of form [Drosophila melanogaster]
[Drosophila abc] [Drosophila def]
