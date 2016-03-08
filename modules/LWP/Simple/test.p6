#!/usr/bin/env perl6

use v6;
use LWP::Simple;


###
### IO::Socket::SSL required.  Installed fine via panda.
###

my $ua = LWP::Simple.new;

### Problems {# {{{


#`{
    I'm frequently getting unexpected results.  I'm not sure why, but I assume that some
    servers are returning a header or headers that LWP can't handle yet.

    The "unexpected result"  is usually just outputting "(Any)".
}

### "could not parse headers"
#my $https_url = 'https://github.com/perl6/perl6-lwp-simple';
#LWP::Simple.getprint($https_url);

### (Any)
#my $https_url = 'https://www.google.com/search?client=ubuntu&channel=fs&q=foo&ie=utf-8&oe=utf-8';
#LWP::Simple.getprint($https_url);

### (Any)
#my $rose_url = 'http://rosettacode.org/wiki/24_game/Solve';
#LWP::Simple.getprint($rose_url);


### This works!
my $https_url = 'https://doc.perl6.org/language.html';
LWP::Simple.getprint($https_url);

### }# }}}

### This works fine.  It even includes a 301 redirect to just "rakudo.org"; 
### LWP-Simple is following that ok.
#my $rak_url = 'http://www.rakudo.org';
#LWP::Simple.getprint($rak_url);


### We could also store that output:
#LWP::Simple.getstore($rak_url, 'rak.txt');











say "end of script";

