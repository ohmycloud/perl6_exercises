#!/usr/bin/env perl6

use v6;


### I've got a note in Evernote (Perl/Rakudo/aaa Danger Will Robinson!) that 
### explains why using $?FILE is dangerous.
###
### If you need to find the invoking program's directory, use this.


use lib 'lib';
use FindBin :ALL;

say $FindBin::Bin;
say $Bin;

