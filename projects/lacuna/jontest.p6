#!/usr/bin/env perl6


use Net::HTTP::GET;

### This shows that Net::HTTP is not completely incapable of hitting SSL 
### websites.  I dunno what the problem is with hitting TLE using SSL.
###
### I'm starting to suspect there's something goofy going on with TLE's SSL 
### implementation.
my $resp    = Net::HTTP::GET("https://modules.perl6.org/");
say $resp.content;

