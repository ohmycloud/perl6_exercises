#!/usr/bin/env perl6

use Config::INI;


=for comment
    This is almost what I'm looking for, except that it doesn't have any 
    ability to re-write files.  I could add that, but I'd rather find a module 
    that already works.
    Trying Config::Simple, which does have a write() method.


if True {
    my $filename = 'one.ini';

    my %h = Config::INI::parse_file($filename);
    say %h<jon><lname>;
    say %h<kermit><lname>;
}

