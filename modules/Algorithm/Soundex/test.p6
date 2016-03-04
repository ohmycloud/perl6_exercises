#!/usr/bin/env perl6

use v6.c;
use Algorithm::Soundex;

my $s = Algorithm::Soundex.new;


my $str     = 'foobar';
my $soundex = $s.soundex($str);

say "The soundex of '$str' is '$soundex'.";


