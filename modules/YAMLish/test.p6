#!/usr/bin/env perl6

use YAMLish;

my $infile = 'in.yml';
my $outfile = 'out.yml';


my $yml = slurp $infile;
my %stuff = load-yaml($yml);
say %stuff;


### Boom.
my $out = to-yaml(%stuff);
spurt($outfile, $out);

