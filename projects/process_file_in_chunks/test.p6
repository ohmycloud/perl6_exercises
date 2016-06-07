#!/usr/bin/env perl6 

my @one = <one one one>;
my @two = <two two two>;

@two.append(@one);
say @two;

