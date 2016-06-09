#!/usr/bin/env perl6 

=begin foo

    .hyper is a method of Iterable.

    It returns another Iterable (a HyperSeq) that is "potentially iterated in parallel".

=end foo

my @arr = <foo bar baz blarg>;

### Prints the individual elements
@arr.hyper.map({.say});


