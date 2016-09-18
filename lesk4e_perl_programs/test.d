#!/usr/bin/perl
#dotplot.pl -- reads two sequences and prints dotplot

# read input
$/ = "";
$_ = <DATA>;
$_ =~ s/#(.*)\n/\n/g;
$_ =~ /^(.*)\n\s*(\d+)\s+(\d+)\s*\n(.*)\n([A-Z\n]*)\*\s*\n(.*)\n([A-Z\n]*)\*/;
$title  = $1;
$nwind  = $2;
$thresh = $3;
$seqt1  = $4;
$seq1   = $5;
$seqt2  = $6;
$seq2   = $7;
$seq1 =~ s/\n//g;
$seq2 =~ s/\n//g;
$n = length($seq1);
$m = length($seq2);

#................................................................................
print "title: $title\nnwind: $nwind\nthresh: $thresh\nseqt1: $seqt1\nseq1: $seq1\nseqt2: $seqt2\nseq2: $seq2\nn: $n\nm: $m\n";
#................................................................................

#print matrix

$dx = 500.0/$n;
$mdx = -$dx;
$dy  = 500.0 / $m;
if ( $dy < $dx ) { $dx = $dy; }
$dy  = $dx;
$xmx = $n * $dx;
$ymx = $m * $dx;

print "0 510 m ($title NWIND = $nwind) show\n";
printf "0 0 m 0 %9.2f l %9.2f %9.2f l %9.2f 0 l c s\n", $ymx, $xmx, $ymx, $xmx;
 
for ( $k = $nwind - $m + 1 ; $k < $n - $nwind ; $k++ ) {
    $i = $k;
    $j = 1;
    print "i: $i, j: $j, k: $k - ";
    if ( $k < 1 ) { $i = 1; $j = 2 - $k; }
    print "i: $i, j: $j, k: $k \n";
    while ( $i <= $n - $nwind && $j <= $m - $nwind ) {
        $_ = 
            ( substr( $seq1, $i - 1, $nwind ) ^ substr( $seq2, $j - 1, $nwind ) );        
        $mismatch = ( $_ =~ s/[^\x0]//g );
        print substr( $seq1, $i - 1, $nwind ) . "\n" . substr( $seq2, $j - 1, $nwind ) . "\n$_\n";
        print $mismatch . "\n";
        if ( $mismatch < $thresh ) {
            $xl = ( $i - 1 ) * $dx;
            $yb = ( $m - $j ) * $dy;
            printf "n %9.2f %9.2f m %9.2f 0 r 0 %9.2f r %9.2f 0 r c f\n",
              $xl, $yb, $dx, $dy, $mdx;
        }
        $i++;
        $j++;
    }
}
print "showpage\n";

__END__
ATPases lamprey / dogfish                  #TITLE
15 6                                       #WINDOW, THRESHOLD
Petromyzon marinus mitochondrion           #SEQUENCE 1
ATGACACTAGATATCTTTGACCAATTTACCTCCCCAACA
ATATTTGGGCTTCCACTAGCCTGATTAGCTATACTAGCCCCTAGCTTA
ATATTAGTTTCACAAACACCAAAATTTATCAAATCTCGTTATCACACACTA
CTTACACCCATCTTAACATCTATTGCCAAACAACTCTTTCTTCCAATAAAC
CAACAAGGGCATAAATGAGCCTTAATTTGTATAGCCTCTATAATATTTATC
TTAATAATTAATCTTTTAGGATTATTACCATATACTTATACACCAACTACC
CAATTATCAATAAACATAGGATTAGCAGTGCCACTATGACTAGCTACTGTC
CTCATTGGGTTACAAAAAAAACCAACAGAAGCCCTAGCCCACTTATTACCA
GAAGGTACCCCAGCAGCACTCATTCCCATATTAATTATCATTGAAACTATT
AGTCTTTTTATCCGACCTATCGCCCTAGGAGTCCGACTAACCGCTAATTTA
ACAGCTGGTCACTTACTTATACAACTAGTTTCTATAACAACCTTTGTAATA
ATTCCTGTCATTTCAATTTCAATTATTACCTCACTACTTCTTCTATTA
CTAACAATTCTGGAGTTAGCTGTTGCTGTAATCCAGGCATATGTATTTATT
CTACTTTTAACTCTTTATCTGCAAGAAAACGTTT*    
Scyliorhinus canicula mitochondrion         #SEQUENCE 2
ATGATTATAAGCTTTTTTGATCAATTCCTAAGTCCCTCCTTTCTAGGA
ATCCCACTAATTGCCCTAGCTATTTCAATTCCATGATTAATATTTCCAACACCAACC
AATCGTTGACTTAATAATCGATTATTAACTCTTCAAGCATGATTTATTAACCGATTTATT
TATCAACTAATACAACCCATAAATTTAGGAGGACATAAATGAGCTATCTTATTTACAGCC
CTAATATTATTTTTAATTACCATCAATCTTCTAGGTCTCCTTCCATATACTTTTACGCCT
ACAACTCAACTTTCTCTTAATATAGCCTTTGCCCTGCCCTTATGGCTTACAACTGTATTA
ATTGGTATATTTAATCAACCAACCATTGCCCTAGGGCACTTATTACCTGAAGGTACCCCA
ACCCCTTTAGTACCAGTACTAATCATTATCGAAACCATCAGTTTATTTATTCGACCATTA
GCCTTAGGAGTCCGATTAACAGCCAACTTAACAGCTGGACATCTCCTTATACAATTAATC
GCAACTGCGGCCTTTGTCCTTTTAACTATAATACCAACCGTGGCCTTACTAACCTCCCTA
GTCCTGTTCCTATTGACTATTTTAGAAGTGGCTGTAGCTATAATTCAAGCATACGTATTT
GTCCTTCTTTTAAGCTTATATCTACAAGAAAACGTATAA*
