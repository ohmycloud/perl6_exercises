#!/usr/bin/env perl6

use v6;

#`{
    The module failed to install via panda (tests broke).  I forced it to 
    install with --notests.

    But it looks like it's not the tests that are broken, but the module.  

    This script doesn't come close to working as advertised; it just blows up.
}

use Terminal::Print;

my $screen = Terminal::Print.new;

if True {
    $screen[9][23] = "%";

    ### Should print '%' to line 9, column 23.
    ### Instead, complains that print-cell is not found for type Str.
    #$screen[9][23].print-cell;

    ### Should print 'F' to line 11, column 21.
    ### Instead, tells me CALL-ME not found for invocant of type Terminal::Print.
    $screen(11, 21, "F");
}

