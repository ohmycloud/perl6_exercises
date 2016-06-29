#!/usr/bin/env perl6

#`{
    distance() is the only fucking thing this module provides, but the code 
    below tells me that "distance" is an undeclared routine.

    However, see ./Damerau/ which does work and provides what this module is 
    supposed to provide.
}

use v6;
use Text::Levenshtein qw(distance);


my $s1 = 'foobar';
my $s2 = 'foobaz';
say distance($s1, $s2);


