#!/home/jon/.rakudo/install/bin/perl6


            my @nums = <1 2 3 'blargle' 4 5>;
            for @nums -> Int $n {
                say $n;
            }
