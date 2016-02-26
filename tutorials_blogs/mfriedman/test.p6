#!/home/jon/.rakudo/install/bin/perl6

sub sayit (Int $number) { "I got $number."; }

my @arr = <1 3 5>;

map { sayit($_).say }, @arr;
