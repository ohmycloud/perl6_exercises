#!/usr/bin/env perl6


### This is almost all perfectly cromulent and p5-y.
###
###             EXCEPT THAT STRING ZERO IS NOW TRUE!
###
### Be sure to see the Gotcha section.



### False
my $unset_var;
say ''.Bool;
say 0.Bool;
say Nil.Bool;
say $unset_var.Bool;
''.say;




### True
my $set_var = 'flurble';
say 'some string'.Bool;
say 1.Bool;
say $set_var.Bool;
''.say;




### Gotcha
my $zero_num = 0;
say $zero_num.Bool;     # False
say 0.Bool;             # False

my $zero_str = '0';
say $zero_str.Bool;     # True (blarg this is going to bite me again and again and again.)
say '0'.Bool;           # True (ibid)



