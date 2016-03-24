#!/usr/bin/env perl6


if True {# {{{

    class Jontest {
        has %.hash;

        method name { say "--{%.hash}--"; %!hash<name> }
    }


    my %hash = ( name => 'Jon' );
    my $j = Jontest.new(:%hash);
    say $j.name;

}# }}}



