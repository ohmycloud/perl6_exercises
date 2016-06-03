#!/usr/bin/env perl6

my $test = True;

repeat {
    my $rv = prompt("change to false? ");

    if $rv ~~ m:i/y/ {
        $test = False;
    }
    else {
        say "OK dimwit.  Try again.";
    }

} while $test;

