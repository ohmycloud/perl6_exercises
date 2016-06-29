#!/usr/bin/env perl6

use v6;
use Terminal::Width;


#`{
    I dunno how to test the two failure modes, since my version is correctly 
    getting the width.  But what you see below is what's documented.

    Docs say this works on Windows 10 and Debian derivatives, and that it 
    should work on OSX.  Untested on anything else.
}



### Report current width of the terminal
my $w1 = terminal-width;
say $w1;






### If we fail to get the width, default to 100
my $w2 = terminal-width :default(100);
say $w2;

### If we fail to get the width, produce a Failure
my $w3 = terminal-width :default(0);
say $w3;


