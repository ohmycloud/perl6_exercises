#!/usr/bin/env perl6

use v6;
use Term::ProgressBar;


### This is just awful.


my $count = 100_000;
my $bar = Term::ProgressBar.new( count => $count, :p, :name('Working...') );

for (1..$count) {
    $bar.update($_);
    $bar.message("$_") unless $_ % 1000;
}

