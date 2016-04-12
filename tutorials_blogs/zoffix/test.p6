#!/usr/bin/env perl6

if True {   # lazy infinite list

    ### The second argument below is NOT the amount we're incrementing by.
    ###
    ### We're specifying the first two elements of the list.  The sequence 
    ### operator (...) figures out our pattern and extends that same pattern 
    ### to infinity.
    my @inf = 0, 2 ... ∞;

        ### So these also work:
        #my @inf = 4, 6 ... 20;     # start at 4, inc by 2
        #my @inf = 5, 8 ... 20;     # start at 5, inc by 3
        #my @inf = 1, 2, 4 ... 50;  # start at 1, inc by 1, then 2, then 4, etc (holy shit)

        ### The attempt here is to add 1, then 2, then 3, then 4, etc.
        ### But that's too complicated for the compiler to figure out, and p6 
        ### tells us
        ###     Unable to deduce arithmetic or geometric sequence.
        #my @inf = 1, 2, 4, 7, 11 ... 50;

        ### Fibonacci
        ### Unable to deduce
        #my @inf = 0, 1, 1, 2, 3, 5 ... 50;



    for @inf -> $i {
        say $i;
        last if $i > 50;
    }

    ### The lazy list only gets evaluated as we iterate through it, so an 
    ### infinite list is fine.
    ###
    ### I'm assuming that what makes this a lazy list is the sequence operator 
    ### itself.

}

