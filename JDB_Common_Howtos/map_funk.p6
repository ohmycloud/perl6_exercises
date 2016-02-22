#!/home/jon/.rakudobrew/bin/perl6


###
### map() _can_ return "no value at all" for certain iterations, but it does 
### so differently from p5.
###


my @numbers = <1 2 3 4 5>;



{
    ### This looks very correct.  It is not.
    my @even = @numbers.values.map({
        ### If the value mod 2 returns a true value, then the value is odd and we 
        ### should return the empty set, ().
        $^v % 2 ?? () !! $v

        ### Right?  GONNNNG!
    });

    say @even;          # [() 2 () 4 ()]
    ###
    ### ACK.  We got actual empty sets returned in place of those odd digits.  
    ### This is not at all what we want.
    ###
}
''.say;



{
    ### Instead of telling map() to return (), we now have to use the term 
    ### "Empty".  The code below is the same as the code above except for the 
    ### addition of Empty.

    my @even = @numbers.values.map({
        ### If the value mod 2 returns a true value, then the value is odd and we 
        ### should return the empty set, ().
        $^v % 2 ?? Empty !! $v
        #          ^^^^^
    });

    say @even;          # [2 4]     And there was much rejoicing

}
