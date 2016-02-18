#!/home/jon/.rakudobrew/bin/perl6

my token ident { oo. }
#my $m = 'foobar' ~~ /<mymatch=ident>/;
my $m = 'foobar' ~~ /oob/;
say $m;
say $m.made;



#$/.make: { .say };

