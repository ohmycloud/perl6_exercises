#!/usr/bin/env perl6

use HTTP::UserAgent;


### All of these URLs work.  I took them from my LWP::Simple test script, 
### where most of them did not work.

#my $url = 'https://doc.perl6.org/language.html';
#my $url = 'https://github.com/perl6/perl6-lwp-simple';
#my $url = 'https://www.google.com/search?client=ubuntu&channel=fs&q=foo&ie=utf-8&oe=utf-8';
my $url = 'http://rosettacode.org/wiki/24_game/Solve';




my $ua = HTTP::UserAgent.new;
my $resp = $ua.get($url);

if $resp.is-success {
    say $resp.content;
}
else {
    die $resp.status-line;
}

