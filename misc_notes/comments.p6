#!/home/jon/.rakudobrew/bin/perl6


###
### Just like p5
###

# this is a comment
say '1';                # this too


###
### Sort of like p5
###
=begin POD

This works as POD.

You apparently need the label -- "begin FOO" and "end FOO" would have worked 
just as well.  I expect the tut will eventually cover POD so no more detail on 
that.

HOWEVER, we don't need to use pod blocks as multi-line comments anymore.  See 
below.

=end POD
say '2';


###
### Well this is handy.
###
#`{

    Multiline comment.  After the "#`", the block is defined by any grouping 
    construct - {}, (), [], maybe others.

    There cannot be any space between the backtick and the opening grouping 
    character.

}
say '3';





say "If you're seeing this, all of the comments in the script worked as comments.";

