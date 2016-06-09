#!/usr/bin/env perl6 

my $c = Channel.new;

try {
    die "foo";
    CATCH {
        say "catching";
        #exit;
        .resume;
    }
}
say "after";

