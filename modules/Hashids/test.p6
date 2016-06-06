#!/usr/bin/env perl6 

### https://github.com/kalkin/perl6-hashids


### Creates reversible hashes from integers.
###
### Allows you to use your primary key in links etc without actually exposing 
### the numeric IDs to users.



use v6;

use Hashids;

my $hashids = Hashids.new('this is my salt');

my $id = 123;



### This works just fine, producing a hash string from an integer.
my $hash = $hashids.encode($id);
say $hash;                                      # YDx



### Going the other direction is a little buggy though.

### This call to decode() produces some excess output.  It looks like some 
### debug junk that the author left in accidentally.
my $id_again = $hashids.decode($hash);
        ### [Dx]
        ### -> Dx

    ### That debug crap doesn't appear to be getting in the way, it's just 
    ### junky looking on the terminal.


### Also, decode() is not returning what the readme says it will.
say $id_again;
    ### the readme says this should be 123, but I'm getting [123].

say $id_again.WHAT;
    ### So this shows that I'm getting back a Array, but the docs say I should 
    ### be getting back an Int.
    ###
    ### Actually, decode()'s retval is shown in the docs as a comment, exactly 
    ### like this:
    ###         my $number = $hashids.decode('YDx');            # 123
    ###
    ### The docs don't explicitly use the word "Int", but that comment, along 
    ### with the $ sigil, both certainly imply that we're getting back a 
    ### scalar Int, not an Array.
    ###
    ### But an Array is what we've got.




=begin stuff

    This looks like one of those modules that could be handy when you need it.

    But decode()'s retval not matching the docs makes me nervous.  I don't 
    think I'd use this at this point, because I'd have to treat that retval as 
    an array, and it wouldn't surprise me if the next version of 
    Hashids::decode actually returns an Int (as expected) rather than the 
    Array I'm now jury-rigging around.

    So if you need this, fill out an issue on github and get it fixed before 
    working around that Array issue.
    
=end stuff
















