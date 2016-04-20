#!/usr/bin/env perl6


use lib 'lib';
use Door;

my @doors = gather { take Door.new(:number($_)) for 1..100 }

my $nth = 1;
while ($nth <= 100) {
    loop (my $i = $nth-1; $i < 100; $i += $nth) {
        @doors[$i].toggle;
    }
    $nth++;
}


for @doors -> $d {
    say "{$d.number}: {$d.state}";
}

