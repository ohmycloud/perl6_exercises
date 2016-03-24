#!/usr/bin/env perl6


if True {# {{{

    class MyOne {
        method foo() {
            return "this is One.foo";
        }
    }

    class MyTwo is MyOne {
        method foo() {
            #say self.parent;
            #say self.parents;
            #my $s = $.parent.foo() ~ " and this is Two.foo";
        }
    }

    my $t = MyTwo.new;
    say $t.foo;

}# }}}



