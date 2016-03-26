#!/usr/bin/env perl6

if False {   # Any# {{{
    
    my $var = any(1,2,3);
    say $var;                       # any(1, 2, 3)

    if $var == 1 { say "OK"; }      # hits
    if $var == 2 { say "OK"; }      # hits
    if $var == 3 { say "OK"; }      # hits

}# }}}
if True {   # None# {{{
    
    my $var = none(1,2,3);
    say $var;                                   # none(1, 2, 3)

    if $var == 1        { say "1 OK"; }         # does not hit
    if $var == 2        { say "2 OK"; }         # does not hit
    if $var == 3        { say "3 OK"; }         # does not hit

    if $var == 4        { say "4 OK"; }         # hits
    if $var == 94875    { say "94875 OK"; }     # hits
    if $var eq 'foobar' { say "foobar OK"; }    # hits

}# }}}


