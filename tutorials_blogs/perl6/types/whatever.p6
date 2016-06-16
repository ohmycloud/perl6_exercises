#!/usr/bin/env perl6

### The star (*) is called "Whatever" and is an actual class.
###
### It stands for "whatever makes sense in that particular context".
###
### It looks vaguely similar to $_, but it's not identical, since $_ still 
### exists in p6.

if False {  # Class demo {{{
    my $v = *;
    say $v.WHAT;                # (Whatever)
}# }}}
if False {  # As part of a Range {{{
    my $v = 1..*;               # The * is interpreted as infinity.
    say $v.WHAT;                # (Range)

    for $v.list -> $num {       # prints out 1 .. 5
        say $num;
        exit if $num >= 5;
    }
}# }}}
if False {  # Generate a code block {{{

    ### * is also used as the multiplication operator.  So a * is only seen as 
    ### a Whatever when it's in "term position".  In this expression:
    ###             * * 2;
    ###     ...the first * is in "term position" and the second one is in 
    ###     "operator position".  So the parser reads the above as "Whatever 
    ###     times two".
    ###
    ### When we assign that expression to a scalar, we generate a code block 
    ### that's the same as
    ###             -> $x { $x * 2 };
    my $x = * * 2;
    say $x(4);                      # 8


    my @arr = <foo bar baz>;
    say @arr.map: *.uc;             # (FOO BAR BAZ)

    ### ...or even...
    my $y = *.uc;
    say @arr.map: $y;               # same thing - (FOO BAR BAZ)

}# }}}
if False {  # In sorting# {{{

    ### Since the array values are quoted, they're going into the array as 
    ### Strings, not Ints.  So they're going to be sorted alpha, not 
    ### numerically.
    my @arr = ('1', '3', '8', '10', '14', '15', '20', '22');
    say @arr.sort;              # (1 20 14 15 20 22 3 8)

    ### That's obviously not what we want.


    ### Prefixing a value with a plus (+) converts it to a numeric value.
    ### 
    ### In my gvim font, it's a little hard to see, but that's a plus followed 
    ### by a splat.
    say @arr.sort: +*;          # (1 3 8 10 14 15 20 22)

    ### That's what we were going for.





}# }}}

