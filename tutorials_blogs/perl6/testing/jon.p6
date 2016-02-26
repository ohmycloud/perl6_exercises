#!/home/jon/.rakudobrew/bin/perl6


sub married (Bool $i-do) {
    fail "But you must!" unless $i-do;
    say "I now pronounce you...";
}

married(False);
married(True);
