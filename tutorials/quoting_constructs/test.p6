#!/home/jon/.rakudobrew/bin/perl6


my $var = "foobar";

#my @arr = qqw/foo bar baz $var/;
            my @arr = «foo bar baz $var»;
#my @arr = <foo bar baz $var>;

say @arr;
