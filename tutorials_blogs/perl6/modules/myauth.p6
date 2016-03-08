#!/usr/bin/env perl6

use v6;
use lib 'lib';

### These all work
use MyAuth::MyAuth;
#use MyAuth::MyAuth:auth<jdbarton>;
#use MyAuth::MyAuth:auth<blajdfghl>;

### This never works (no "auth")
#use MyAuth::MyAuth:<jdbarton>;

my $m = Jontest.new;
say $m.do_stuff;

