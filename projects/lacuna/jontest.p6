#!/usr/bin/env perl6

use v6;


my $var = '//www.example.com';
say 'foo' unless $var ~~ /^ http: /;

