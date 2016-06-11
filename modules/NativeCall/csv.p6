#!/usr/bin/env perl6

use v6;
use NativeCall;

### Remember to copy libcsv.so.3 from /usr/local/lib to /usr/lib first.


### Works
sub csv_init() is native('csv', v3) {};
my $t = csv_init();
say 'here';


### This is going to take some work.
#sub csv_parse(Pointer[void], Pointer[void], int32,  ) is native('csv') {};

