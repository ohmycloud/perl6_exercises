#!/home/jon/.rakudobrew/bin/perl6


### 
### Pragmas not mentioned in here should be the same as in p5
###
### I'm mainly talking about "use lib ..." which does work the same way.
###





### strict, warnings
###
###     On by default


### autodie
###
###     functions that were altered by autodie now throw exceptions by default
###     unless you explicitly test the retval.
###
#my $fh = open "nonexistent_file.txt", :r;
#   Failed to open file /home/jon/work/rakudo/tutorials/five-to-six/nonexistent_file.txt: no such file or directory

### The tut says that open et al throw an exception "unless you test the 
### return value explicitly".  That sounds like it means you have to test $fh, 
### but in doing some more checking, it seems to mean you have to do this:
###
if 'nonexistent_file'.IO.e {
    my $fh = open "nonexistent_file.txt", :r;
    ### However, this results in $fh being lexically bound to this block, and 
    ### seems inconvenient.  Dunno if there's a better way.
}
else {
    say "Hey that file doesn't exist.";
}


### base, parent
###
### Both have been replaced by 'is'.
###

### Perl 5:
#package Gorilla;
#use base qw(Ape);

### Perl 6:
class Ape {};
class Gorilla is Ape {};


### bigint, bignum, bigrat
###
### No longer relevant.  Numbers are of arbitrary precision (I'm lying a 
### little here, but it's close enough to the truth).


### constant
###
### 'constant' is now a formal declarator, just like 'my'.
constant $PI = 3.14;
#$PI = '3.0';           # sorry Kansas, this throws an exception.  "Cannot assign to an immutable value".


### mro, utf8
###
### Both no longer relevant.
### 
### p6 always uses the C3 method resolution order (which I never fiddled with 
### anyway).
###
### p6 source is always expected to be in utf8.


### vars
###
### Discouraged in p6.
###
### I might have used this once upon a time, but probably not since KSI, so 
### not using it in p6 shouldn't be a problem.

