#!/usr/bin/env perl6

use v6;

my $hash = (
    foo => 'bar'
);


my $foo = try { die 'blarg' };
say "-$!-" if $!;
say $foo;

