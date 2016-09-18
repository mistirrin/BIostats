#!/usr/bin/perl
$/ = "";
@fragments = split("\n",<DATA>);
foreach (@fragments) { $firstfragment{$_} = $_; }
foreach $i (@fragments) {
foreach $j (@fragments) { unless ($i eq $j) {
($combine = $i . "XXX" . $j) =~ /([\S ]{2,})XXX\1/;
(length($1) <= length($successor{$i})) || { $successor{$i} = $j };
}
undef $firstfragment{$successor{$i}};
}
$test = $outstring = join "", values(%firstfragment);
while ($test = $successor{$test}) { ($outstring .= "XXX" . $test) =~ s/([\S ]+)
XXX\1/\1/; }
$outstring =~ s/\\n/\n/g; print "$outstring\n";
__END__
the men and women merely players;\n
one man in his time
All the world's
their entrances,\nand one man
stage,\nAnd all the men and women
They have their exits and their entrances,\n
world's a stage,\nAnd all
their entrances,\nand one man
in his time plays many parts.
merely players;\nThey have

