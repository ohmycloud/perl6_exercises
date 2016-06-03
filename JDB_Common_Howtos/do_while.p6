#!/usr/bin/env perl6

### do...while is now repeat...while.

my $test = True;

repeat {
    my $rv = prompt("change to false? ");
    $test = False if $rv ~~ m:i/y/;
} while $test;


