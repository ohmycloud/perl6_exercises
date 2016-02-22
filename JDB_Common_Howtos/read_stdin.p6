#!/home/jon/.rakudo/install/bin/perl6

say "Enter any string, include some integers mixed in.";

### Reads the user's response from STDIN
my $line = $*IN.get();

### Comb through the string, grabbing only the numbers.  Cast them all to Ints 
### and sort them.
my @numbers = $line.comb( /\d+/ )».Int.sort;

### Sorted array of numbers.
say @numbers;


