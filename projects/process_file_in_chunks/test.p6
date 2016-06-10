#!/usr/bin/env perl6 



my $csv = (1..20).join(',');

my $thing = $csv.split(',');

#my @vals = map { fizzbuzz($_.Int) }, [$csv.split(',')];
#say @vals;


my $out = (map { fizzbuzz($_.Int) }, [$csv.split(',')]).join(',');
say $out;



sub fizzbuzz(Int $n) returns Str {# {{{
    return 'fizzbuzz' unless $n % 15;
    return 'buzz' unless $n % 5;
    return 'fizz' unless $n % 3;
    return $n.Str;
}# }}}

