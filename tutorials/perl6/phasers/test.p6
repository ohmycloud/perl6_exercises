#!/home/jon/.rakudobrew/bin/perl6

BEGIN my $compiletime = now;

sleep 4;

END {
    my $endtime = now;
    say "Compiled at $compiletime, ended at $endtime.";
    say "A difference of " ~ ($endtime - $compiletime) ~ " seconds.";
}
