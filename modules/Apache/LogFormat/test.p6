#!/usr/bin/env perl6

use Apache::LogFormat;

my $fmt = Apache::LogFormat.combined;


### No documentation on what the args are supposed to be.  I guess that the 
### format is common enough that the author thinks there's no need to document 
### it.  Bullshit.


my $line = $fmt.format(%*ENV, $rest_of_args_go_here );


