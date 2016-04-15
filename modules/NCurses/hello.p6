#!/usr/bin/env perl6

use NCurses;

my $win = initscr;
die "no init" unless $win.defined;

### Display a string starting at top left
printw("Hello, World!");

### Move cursor down 5 and right 10, then display another string
mvaddstr( 5, 10, "Press any key to exit");

### Docs say this is "needed", but I don't see any difference in the output 
### whether it's commented out or not.
nc_refresh;

### Wait for user input
while getch() < 0 {};

endwin;

