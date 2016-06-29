#!/usr/bin/env perl6

use v6;
use Text::Indented;

#`{
    No examples given in docs, I had to dig into t/ to find out how this is 
    supposed to work.

    Doesn't install via panda.


    Not ready for prime time.
}

my $str = q:to/EOF/;
L1
    L2.1
        L3.1
        L3.2
    L2.2
EOF

my $r = parse($str);
say $r;


