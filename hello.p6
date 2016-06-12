#!/usr/bin/env perl6

if True {
    my $greet = "Hello, World!";
    say $greet.WHAT;
    say $greet.perl;
    say $greet;
}

my @arr = <one two three>;
say @arr.join(',');

#`{
This is a multiline comment that will get ignored like any
other comment.

That's:
    Hash
    Backtick
    Any opening grouping construct -- (, [, the curly brace I used, etc
        the comment
    The matching closing grouping construct

HOWEVER, note that I cannot include a closing brace in here, which seems 
pretty obvious.  But I cannot include another opening brace either.
    
}

say "this comes after the comment";
