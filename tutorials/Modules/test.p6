#!/home/jon/.rakudobrew/bin/perl6

use lib 'lib';
use JonTest;
say $var;
say @array;
say %hash;
doit();

my $jt = ShortName.new;
$jt.do_stuff;

