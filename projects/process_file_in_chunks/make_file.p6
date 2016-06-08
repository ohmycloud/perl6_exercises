#!/usr/bin/env perl6 

my $fh = open 'data.txt', :w;
for (1..5_000) -> $n {
    $fh.say($n);
}

