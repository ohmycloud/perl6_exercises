#!/usr/bin/env perl6 

my $c = Channel.new;


my @arr = <one two 0 three four>;


@arr = splice @arr, 2;
say @arr; exit;

loop ( my $i = 0; $i < 17; $i++ ){
    last unless defined @arr[$i];
    say @arr[$i];
}
