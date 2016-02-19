#!/home/jon/.rakudobrew/bin/perl6

###
### comb
### 
### splits a string up into a list.  Unlike split, with comb, we specify what 
### we want to keep, not what we want to throw away.
my $str = 'abcdefghijklmnopqrstuvwxyz';
my @arr = $str.comb(/<[aeiou]>/);
say @arr;




