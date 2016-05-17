#!/home/jon/.rakudobrew/bin/perl6

            class Example {
                has $.foo = 'foo';
                has $.bar = 'bar';
                method BUILD (:$foo, :$bar) {
                    say $foo;
                    say $bar;
                }
            }

            my $e = Example.new( foo => 'FOO', bar => 'BAR' );

