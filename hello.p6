#!/home/jon/.rakudobrew/bin/perl6

if True {
    my $greet = "Hello, World!";
    say $greet.WHAT;
    say $greet.perl;
    say $greet;
}

my @arr = <one two three>;
say @arr.join(',');
