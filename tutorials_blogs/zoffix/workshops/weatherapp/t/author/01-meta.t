
### This will only run when either the AUTHOR_TESTING or the ALL_TESTING env 
### var is true.
use Test::When <author>;

use Test;
use Test::META;
plan 1;

meta-ok;

