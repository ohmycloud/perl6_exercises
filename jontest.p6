#!/usr/bin/env perl6


my $str = '(foobar';

given $str {
    when /'fooba'/ {
        say "here 1";
    }
}

