#!/home/jon/.rakudobrew/bin/perl6


'foobarFOObaz' ~~ m:i/ foo <!before baz> /;
say ~$/;

'foobarFOObaz' ~~ m:i/ <!after bar> foo /;         # FOO
say ~$/;
