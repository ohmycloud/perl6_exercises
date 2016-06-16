#!/usr/bin/env perl6

# https://doc.perl6.org/type/Array


if False {  # Creating {{{

    ### There are two ways to indicate an array.


    ### First, with square brackets
    say [1, 2, 3, 4].WHAT;                  # (Array)


    ### Second, with an @ variable
    ###
    ### Here, the RHS is already an array, which we're assigning to the @arr1 
    ### variable which is also marked as being an array.  This assignment 
    ### DTRT.
    my @arr1 = ['one', 'two', 'three'];
    say @arr1;                              # [one two three]
    say @arr1.WHAT;                         # (Array)
    
    ### However, if the RHS is something other than an array, but it's still 
    ### list-y, it will become an Array when we assign it to an @ variable.
    say <one two three>.WHAT;               # (List)
    my @arr2 = <one two three>;
    say @arr2.WHAT;                         # (Array)

}# }}}
if False {  # Subscripting {{{

    my @arr = <11 22 33 44 55>;

    ### Fine, this is as expected
    say @arr[0];            # 11
    say @arr[4];            # 55

    ### However, this shit blows the fuck up.
    #say @arr[-1];
            ### "Unsupported use of a negative -1 subscript to index..."

            ### FWIW, a "negative -1 subscript" would be '1'.  Part of me 
            ### thinks that's just the English pedant in me, but a double 
            ### negative absofuckinglutely has meaning in programming.  I do 
            ### not like the wording of that error.

    ### Anyway, to subscript from the end, we need to use our friend the 
    ### Whatever Star.  For reasons that are not blatantly obvious to me right 
    ### now, using that indicates "end of array".
    say @arr[*-1];          # 55
    say @arr[*-3];          # 33

}# }}}
if False {  # Adding values {{{

    ### The p6 array has familiar sounding methods, like push and unshift.
    my @arr = <two three four>;
    @arr.push('five');
    @arr.unshift('one');
    @arr.say;                           # [one two three four five]


    ### Fantastic.  But both .push and .unshift expect SCALAR arguments.  If 
    ### you try to .push or .unshift an array onto another array, you're going 
    ### to get funk:
    my @arr2 = <one two>;
    my @end2 = <three four>;
    @arr2.push(@end2);
    @arr2.say;                          # [one two [three four]]

    ### Well, shit.  That took @end, treated it as a single entity (which in 
    ### Perl6 it now is), and pushed that single entity onto the end of @arr2.

    ### If you want to join two arrays together, use .append or .prepend 
    ### instead of .push or unshift.
    my @start3  = <one two>;
    my @middle3 = <three four>;
    my @end3    = <five six>;

    @middle3.prepend(@start3);
    @middle3.append(@end3);
    say @middle3;                       # [one two three four five six]

    ### Ahhh, that's the stuff.

}# }}}

