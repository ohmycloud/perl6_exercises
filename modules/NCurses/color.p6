#!/usr/bin/env perl6

use NCurses;

my $win = initscr;
die "no init" unless $win.defined;



### This lets our term know we're going to start messing with colors.  It also 
### turns the background black.
start_color();


### This perl6 implementation of ncurses gives us 7 color pair slots.  It 
### looks like that number (7) is arbitrary to the NCurses module.
### 
### In the C implementation, you just pass an integer to init_pair() and then 
### pass that same int as an argument to COLOR_PAIR() to specify which color 
### pair you want to use, giving you as many slots as you want.
###
### The p6 implementation uses COLOR_PAIR_1 to COLOR_PAIR_7 as constants 
### instead of allowing you to pass an argument to COLOR_PAIR().
###
### Dunno why the change.
init_pair(7, COLOR_RED, COLOR_GREEN);   # slot, text color, background color


### Now that we've initialized slot 7 (which slot to use is up to you), turn 
### the colors in that slot on...
attron(COLOR_PAIR_7);
### ...and print some output...
printw("Hello, World!\n");
### ...and turn the colors back off again.
attroff(COLOR_PAIR_7);


### Init another color slot, and turn it on along with the underline and bold 
### attributes.
init_pair(1, COLOR_CYAN, COLOR_MAGENTA);   # slot, text color, background color
attron(COLOR_PAIR_1);
attron(A_BOLD);
attron(A_UNDERLINE);
printw("This is underlined and bold (and ugly).\n");


### Turn all that crap off again.
attroff(A_UNDERLINE);
attroff(A_BOLD);
attroff(COLOR_PAIR_1);
printw("This is normal again.\n");



### Back to the default color again.
### Note that this is not moving down 5 lines.  It's moving to the fifth line.  
### So if the stuff we'd already printed out exceeds 5 lines, the following 
### will overwrite some of the previous text.
mvaddstr( 5, 10, "Press any key to exit");



### Docs say this is "needed", but I don't see any difference in the output 
### whether it's commented out or not.
nc_refresh;

### Wait for user input
while getch() < 0 {};

endwin;

