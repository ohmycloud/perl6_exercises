#!/usr/bin/env perl6


if True {# {{{

    sub foo (Str $a where {$a.chars >= 3}) {
        say $a;
    }

    foo('bl');

}# }}}



