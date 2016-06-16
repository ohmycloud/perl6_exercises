#!/usr/bin/env perl6

### A Pair is what you make hashes out of, eg
###     age => 5
### But it can exist on its own as well.


if True {

    ### Fat comma, very similar to p5
    my $p1 = Pair.new( key => 'age', value => 5 );
    say $p1;     # age => 5

        ### As expected, the fat comma autoquotes the LHS.  But you can avoid 
        ### that by wrapping the LHS in parens.  Here, the actual Pair $p1 is 
        ### the key for $p2:
        my $p2 = ($p1) => 'blarg';
        say $p2;        # (age => 5) => blarg


    ### Colon-Pair syntax does the same thing as the fat comma
    my $p3 = :age(5);
    say $p3;    # age => 5
}

