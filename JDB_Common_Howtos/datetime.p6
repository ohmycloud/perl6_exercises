#!/usr/bin/env perl6

if True {

    my $dt = DateTime.new(
        :year(2016),
        :month(3),
        :day(16),
        :hour(14),
        :minute(13),
        :second(40),
        :timezone( -1 * 4 * 60 * 60 ),      # seconds offset from UTC.  4 not 5 because DST right now.
    );

    say $dt.year;
    say $dt.month;
    say $dt.timezone;

}
