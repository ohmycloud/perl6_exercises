#!/usr/bin/env perl6

if False {   # Any# {{{
    
    my $var = any(1,2,3);
    say $var;                       # any(1, 2, 3)

    if $var == 1 { say "OK"; }      # hits
    if $var == 2 { say "OK"; }      # hits
    if $var == 3 { say "OK"; }      # hits

}# }}}
if False {   # None# {{{
    
    my $var = none(1,2,3);
    say $var;                                   # none(1, 2, 3)

    if $var == 1        { say "1 OK"; }         # does not hit
    if $var == 2        { say "2 OK"; }         # does not hit
    if $var == 3        { say "3 OK"; }         # does not hit

    if $var == 4        { say "4 OK"; }         # hits
    if $var == 94875    { say "94875 OK"; }     # hits
    if $var eq 'foobar' { say "foobar OK"; }    # hits

}# }}}
if True {   # As an enum# {{{
    
    ### This is awesome.

    my $parties = any('democrat', 'republican');

    ### Pick one.
    #my $arg_from_user = 'democrat';
    #my $arg_from_user = 'republican';
    my $arg_from_user = 'independent';

    if $arg_from_user eq $parties {
        say "You can vote $arg_from_user";
    }
    else {
        say "$arg_from_user isn't a real party.";
    }

    ### And no, I'm not anti-independent.  It's Friday night, I've had a few 
    ### drinks, and this is the first stupid example that occurred to me.  
    ### Don't get your panties in a bunch; it's a programming example, not a 
    ### political statement.

}# }}}


