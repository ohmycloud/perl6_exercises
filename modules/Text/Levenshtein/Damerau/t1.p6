#!/usr/bin/env perl6

use v6;
use Text::Levenshtein::Damerau;

#`{
    Works.
    https://github.com/ugexe/Perl6-Text--Levenshtein--Damerau
}

my $s1 = 'Neil';
my $s2 = 'Niel';

### Damerau Levenshtein distance
say dld($s1, $s2);                  # 1

### Levenshtein distance
say ld($s1, $s2);                   # 2


