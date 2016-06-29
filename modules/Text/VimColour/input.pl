#!/usr/bin/env perl

use v5.20;                      # or later to get signatures
use utf8;                       # so literals and identifiers can be in UTF-8
use warnings;                   # on by default
use warnings  qw(FATAL utf8);   # fatalize encoding glitches
use open      qw(:std :utf8);   # undeclared streams in UTF-8

use feature qw(signatures);
no warnings qw(experimental::signatures);

### Good ol fashioned perl5.

my @colors = qw(red orange green blue);
for my $c(@colors) {
    say "-->$_<--";
}

my %h = (
    foo => 'bar',
    john => 'koch',
    jon => 'barton',
    kermit => 'jackson',
);

while( my($n,$v) = each %h ) {
    say "-$n- -$v-";
}


sub how_about_signatures($str, $def = 'default') {
    say "I got $str and $def.";
}


