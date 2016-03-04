#!/usr/bin/env perl6

use LWP::Simple;


###
### IO::Socket::SSL required.  Installed fine via panda.
###

my $ua = LWP::Simple.new;


### Using this I get "could not parse headers" exception.  Probably 
### SSL-related.
#my $url = 'https://github.com/perl6/perl6-lwp-simple';
#my $content = $ua.get($url);

### This doesn't throw any exceptions.
my $url = 'http://rosettacode.org/wiki/24_game/Solve';
my $content = $ua.get($url);


### But this just prints "(Any)".  The module has zero docu on its github 
### page, and "perl6 --doc" doesn't just work for a module unless it's been 
### pointed at the actual module file, and I haven't yet figured out where p6 
### stores that stuff.
say $content;

