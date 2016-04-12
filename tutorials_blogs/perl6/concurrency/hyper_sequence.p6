#!/usr/bin/env perl6


### Standard loop
### Works as expected, with a 1-second sleep between each line of output.
my $t1 = now;
for (1..4) {
    say "Doing $_";
    sleep 1;
}
say now - $t1;      # 4.0024260



### Make it fastar! by turning it into a hyper sequence:
my $t2 = now;
for (1..4).race( batch => 1) {
    say "Doing $_";
    sleep 1;
}
say now - $t2;      # 1.0024260 (!)



=begin pod
    So we took a regular loop and tacked
        .race( batch => 1 )
    onto the end of it, and our regular for loop got threaded out automatically.

    The default batch size is 64, which wouldn't help us out in this example, so 
    the example changes it to 1.  But if you had a list of hundreds or thousands 
    of items and 64 batches were acceptable, the code could be simply:
            for (1..4).race {
                say "Doing $_";
                sleep 1;
            }
=end pod

