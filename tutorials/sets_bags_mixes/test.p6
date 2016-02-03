#!/home/jon/.rakudobrew/bin/perl6

my $s = Bag.new('red', 'blue', 'green', 'red', 'red');
say $s;

my $new = 'red' ⊎ $s;

say $s;
say $new;
