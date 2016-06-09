#!/usr/bin/env perl6 

use v6;

my $in_file     = 'data.txt'.IO;
my $max_files   = 40;


### This script exhibits BAD THING 1 (see ../README).  It does occasionally 
### run without any error.  The larger your $max_files setting is, the more 
### likely you are to see the error.  I've seen the error with $max_files as 
### low as 5, but it took a lot of repeated runnings.  I generally leave it at 
### 40.
###
### To see the error(s):
###     $ rm out_channel/*
###     $ ./error.txt
###
###     no error?  lather rinse repeat till you get one.
### 
###
###
### Where ../channel_process.p6 has a bunch of code to read an input file in 
### chunks, this has none of that.  All we're doing here is trying to open a 
### bunch of text files.
###
###
### I found these online that look vaguely similar to what I'm seeing:
###
### Bug 1:
###     https://rt.perl.org/Public/Bug/Display.html?id=124391
###
### Bug 2:
###     https://github.com/tadzik/panda/issues/263
###     This was actually filed as a bug with Panda, but it looks like similar 
###     behavior in Perl6 that was causing the panda bug.




sub create_files(Int $n) {
    my $fh = open "output/{$n}.txt", :w;
    if $fh ~~ Failure {
        say $fh.exception;
    }
}



my @promises;
for 1..$max_files -> $n {
    @promises.push( start {create_files($n)} );
}
await @promises;

