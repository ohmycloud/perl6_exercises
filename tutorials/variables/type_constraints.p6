#!/home/jon/.rakudobrew/bin/perl6


my Int $x = 42;
say $x;

### Obviously this no worky-worky.
###     Type check failed in assignment to $y; expected Int but got Str
#my Int $y = 'foo';
#say $y;

my Int $y;
#$y = "bar";     # derp.
$y = 4;
say $y;
say '';


### Arrays and hashes get initialized as object of the Array and Hash classes 
### (oddly enough).


### You can change a variable's default value:
my Int $answer is default(42);
say $answer;    # 42

$answer = 300;
say $answer;    # 300

### Fine, as expected.  Now, re-set the variable to Nil.  This is analogous to 
### calling a Moose attribute's clearer method:
$answer = Nil;
say $answer;    # Neato - 42 again!

