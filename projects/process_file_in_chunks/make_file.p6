#!/usr/bin/env perl6 

my $fh = open 'test.txt', :w;
for (1..10_000) -> $n {
    $fh.say($n);
}

