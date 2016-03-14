#!/usr/bin/env perl6


if True {# {{{
    
    class Jontest {# {{{
        has $.foo is rw = 'jontest preset foo';
        has $.bar;

        method new(Str $var) {
            my $self = self.bless(foo => $var);
        }
        submethod BUILD (:$foo) {
            say "Jontest BUILD got var <$foo>.";
            $!foo = 'jontest foo';
        }

    }# }}}
    class Two is Jontest {# {{{

        method new(Str $var) {
            my $self = self.bless(foo => $var);
        }
        submethod BUILD (:$foo) {
            say "Two BUILD got var <$foo>.";
        }

        method blarg {
            $!foo;
        }
    }# }}}






    my $j = Jontest.new( 'string arg' );
    say "Jontest foo: " ~ $j.foo;
    ''.say;


    my $t = Two.new( 'string arg' );
    say "Two foo: " ~ $t.foo;
    say "Two blarg: " ~ $t.blarg;
    ''.say;



}# }}}
if False {# {{{

    my Int $num = 123;
    my $str = $num.Str;
    say "$str";

}# }}}


