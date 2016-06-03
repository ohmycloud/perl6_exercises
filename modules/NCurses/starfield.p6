#!/usr/bin/env perl6

use NCurses;

=begin pod

    The original code also use the straight for loop
        for @stars -> $star {

    I modified it to
        for @stars.race( batch => 16) -> $star {

    When the sleeptime constant is .05, which is what the original used, 
    there's no clear visual difference between those two for loops.  But if 
    you decrease that sleeptime to .005 or even .001, there's a definite 
    visual difference between the standard for loop and the threaded one.


    If the user re-sizes the screen after starting the program, nothing is 
    currently being done to change $max_x or $max_y.  In a perfect world, we'd 
    deal with that.
        Actually, when I resize my term, the program sees that as keyboard 
        input (huzzuh?) and ends.


    Also, once a star is created, its speed is set and never changes.  So two 
    stars on the same X will always be exactly the same distance apart.  It'd 
    be nice to periodically change a given star's speed to break up that even 
    spacing.

=end pod

constant numstars   = 100;
constant sleeptime  = .010;
constant max-speed = 4;

class Star {# {{{
    has Int $.max_x;
    has Int $.max_y;
    has Int $.x;
    has Int $.y;
    has Int $.speed;

    submethod BUILD(:$!max_x, :$!max_y) {
        $!x     = (^$!max_x).pick;          # random x from 0 to < screen-x
        $!y     = (^$!max_y).pick;          # random y from 0 to < screen-y
        $!speed = (1 .. max-speed).pick;    # random speed from 1 to max-speed (inclusive)
    }

    method move {
        $!x = ($!x >= $!speed) ?? $!x - $!speed !! $.max_x;
    }
}# }}}



my $win = initscr;
die "no init" unless $win.defined;


### Get current screen limits
my $max_x = getmaxx($win);
my $max_y = getmaxy($win);




my Star @stars = gather { take Star.new(:$max_x, :$max_y) for ^numstars }


curs_set(0);
repeat {
    clear;
    for @stars.race( batch => 8) -> $star {
    #for @stars -> $star {
        $star.move;
        mvaddstr( $star.y, $star.x, '.' );
    }
    nc_refresh;
    sleep( sleeptime );
} while getch() < 0;


endwin;

