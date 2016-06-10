#!/usr/bin/env perl

use v5.24;

use Text::CSV_PP;
use Time::HiRes qw(gettimeofday tv_interval);

my $start = [gettimeofday];

my $csv = Text::CSV_PP->new({ eol => "\012" }) or die 'wtf';
open my $ifh, '<', 'data.txt' or die $!;
open my $ofh, '>', 'output/five.txt' or die $!;

while( my $line = $csv->getline($ifh) ) {
    my @out = map{ fizzbuzz($_) }@{$line};
    $csv->print($ofh, \@out);
}

close $ifh;
close $ofh;


say "That took ", tv_interval($start, [gettimeofday]), " seconds.";





sub fizzbuzz {# {{{
    my $n = shift;
    return 'fizzbuzz' unless $n % 15;
    return 'buzz' unless $n % 5;
    return 'fizz' unless $n % 3;
    return $n;
}# }}}


