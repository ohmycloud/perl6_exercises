#!/usr/bin/env perl6


if True {# {{{

    my @nums = <1 2 3 4 5>;
    say @nums;

    my @odd = @nums.grep({$_%2});
    say @odd;

    say "FooBar".lc;

}# }}}



