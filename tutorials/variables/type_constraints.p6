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


### A variable with no type constraint on declaration is of type "Mu", which 
### is a Japanese and Korean word meaning "not have, without".  Perl6 is also 
### backronyming it (and I'm verbing nouns) as "Most Undefined".
###     http://doc.perl6.org/type/Mu
my $mu;

### So this variable is typed as "Mu".  Since it was not assigned a value, it 
### starts out assigned as an object of the Any class.
###     http://doc.perl6.org/type/Any


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






