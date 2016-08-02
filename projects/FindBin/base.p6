#!/usr/bin/env perl6


#say $?FILE;
#say $?FILE.IO.parent.Str;
#say $?FILE.IO.parent.parent.Str;
#say '------------';


say $?FILE;
say $?FILE.IO.abspath;
say $?FILE.IO.abspath.IO.parent.Str;
say $?FILE.IO.abspath.IO.parent.parent.Str;
say '------------';

#my $here = $?FILE.IO.parent.parent.Str;#dirname;
#say $here;

