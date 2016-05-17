#!/usr/bin/env perl6

my $fn = 'file_tests.p6';


### https://doc.perl6.org/type/IO::Path#File_Test_operators


if $fn.IO.e {
    say "$fn exists using method test.";
} else { die "GONNG 1" }

### I prefer the method tests as just easier to look at, but you can do this 
### as well:
if $fn.IO ~~ :e {
    say "$fn exists using trait test.";
} else { die "GONNG 2" }
''.say;


### The .rw test is documented, but 05/13/2016 it's returning Int (1) instead 
### of the expected Boolean.  Whoopsie.
if $fn.IO.r { say "$fn is readable." }
if $fn.IO.w { say "$fn is writable." }
if $fn.IO.x { say "$fn is executable." }
#if $fn.IO.rw { say "$fn is readable and writable." }
if $fn.IO.rwx { say "$fn is readable, writable, and executable." }
''.say;


if $fn.IO.f { say "$fn is a file." }
if $fn.IO.l { say "$fn is a symlink." } else { say "$fn is not a symlink." }
if $fn.IO.d { say "$fn is a directory." } else { say "$fn is not a directory." }
''.say;

say "$fn contains " ~ $fn.IO.s ~ " bytes.";
say "$fn was most recently modified on " ~ $fn.IO.modified ~ ".";
say "$fn was most recently accessed on " ~ $fn.IO.accessed ~ ".";
say "$fn was most recently changed on " ~ $fn.IO.changed ~ ".";
say "That modified date is more easily read as " ~ DateTime.new($fn.IO.modified) ~ '.';
''.say;

