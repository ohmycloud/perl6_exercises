#!/home/jon/.rakudobrew/bin/perl6

my $s1 = "foo";
my $s2 = "bar";
say $s1 leg $s2;
say $s2 leg $s1;


#my $truth = True;
my $truth = False;
if ! $truth {
    say "it's false"
}
else {
    say "it's true";
}


say 'foo' x 3;
my @arr = 'foo' xx 3;
say @arr;

