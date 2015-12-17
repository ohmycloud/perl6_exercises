

### This goes along with the code in ./modules.p6.



unit module TestModule;

sub foo($a) is export {
    say "foo got $a.";
}
sub bar($a) is export {
    say "bar got $a.";
}


sub baz($a) {
    say "baz got $a.";
}


### Note that I do not need the p5-ubiquitous
###     1;
### at the end of this file.
