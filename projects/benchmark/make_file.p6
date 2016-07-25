#!/usr/bin/env perl6 


my $max_recs = 10_000;

my $fh = open 'data.txt', :w;
for (1..$max_recs) -> $n {
    $fh.say( (1..100).join(',') );
}

