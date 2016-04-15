#!/usr/bin/env perl6

use NCurses;

my $win = initscr;
die "no init" unless $win.defined;

my $min_x = getbegx($win);
my $max_x = getmaxx($win);
my $min_y = getbegy($win);
my $max_y = getmaxy($win);

say $min_x;
say $max_x;
say $min_y;
say $max_y;

