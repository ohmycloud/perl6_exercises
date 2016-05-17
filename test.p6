#!/usr/bin/env perl6


sub jontest(:$str --> Array) {
    say $str;
    my @a = <one two three>;
    return @a;
}


my @b = jontest(:str('hi'));
say @b;

