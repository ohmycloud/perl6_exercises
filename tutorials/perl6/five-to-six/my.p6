#!/home/jon/.rakudobrew/bin/perl6


### This file isn't much of an example, just a warning that you cannot do this 
### anymore:
        #my @arr, %hash;
        #my( @arr, %hash );

### Those both produce a compile error.  Looks like we now must do this:
        my @arr;
        my %hash;

