#!/usr/bin/env perl6 


my $max = 5000;

my $fh = open 'data.txt', :w;
for (1..$max) -> $n {
    $fh.say($n);
}

