#!/usr/bin/env perl6


use Net::HTTP::GET;

### This shows that Net::HTTP is not completely incapable of hitting SSL 
### websites.  I dunno what the problem is with hitting TLE using SSL.
###
### I can't hit TLE servers this way, but I also can't hit the Amazon server 
### that's hosting the captcha images, so I can't really just blame TLE.
###
### I don't know why I can hit some SSL sites and not others.  I might need to 
### upgrade OpenSSL.

### This works.
my $resp    = Net::HTTP::GET("https://modules.perl6.org/");
say $resp.content;

