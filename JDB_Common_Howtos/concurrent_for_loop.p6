#!/usr/bin/env perl6 


### http://blogs.perl.org/users/zoffix_znet/2016/04/perl-6-is-slower-than-my-fat-momma.html


my @arr = 1..100;



### The default is to process in batches of 64.
### So, if I'm understanding correctly, the following will create two threads, 
### one with 64 elements and one with 36, and process them concurrently.
if False {
    my $start = now;
    for @arr.race() -> $elem {
        $elem.say;
        sleep 1;
    }
    ### batch 64 -  64 secs (makes sense)
}


### If you want to change that default batch size of 64:
if True {
    my $start = now;
    for @arr.race( batch => 50 ) -> $elem {
        $elem.say;
        sleep 1;
    }
    say "That took {now - $start} seconds.";

    ### batch 2  - 26 secs
    ### batch 4  - 28 secs
    ### batch 8  - 28 secs
    ### batch 10 - 30 secs
    ### batch 16 - 32 secs
    ### batch 32 - 32 secs
    ### batch 50 - 50 secs (makes sense)
}



