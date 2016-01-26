#!/home/jon/.rakudobrew/bin/perl6

use experimental :cached;

            subset NonNegativeInt of Int where * >= 0;
            
            #sub fib(NonNegativeInt $nth) {
            sub fib(NonNegativeInt $nth) is cached {
                given $nth {
                    when 0 { 0 }
                    when 1 { 1 }
                    default { fib($nth-1) + fib($nth-2) }
                }
            }

            say fib(20);
            say fib(30);



