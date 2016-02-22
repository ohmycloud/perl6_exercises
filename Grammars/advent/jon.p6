#!/home/jon/.rakudobrew/bin/perl6

my $correct;
my $total;



sub foobar {
    return <1 2>
}

($correct, $total) = foobar();
say "-$correct-";
say $total;

