#!/usr/bin/env perl6


### Works fine.




use Net::DNS;

my $res = Net::DNS.new('8.8.8.8');          # Google open DNS server.

#my @addresses = $res.lookup('A', 'cdsllc.com');
my @addresses = $res.lookup('A', 'google.com');

for @addresses -> $a {
    say $a;
    say $a.owner-name.join('.');
    say $a.octets.join('.');
    '---------'.say;
}

