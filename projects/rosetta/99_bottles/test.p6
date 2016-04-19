#!/usr/bin/env perl6

class Song {
    has Int $.bottles = 99;
    has Str @.line_three = (
        "Take one down, pass it around",
        "If one of em fell, what the hell",
        "If one of those bottles should happen to fall",
    );

    method container    { $.bottles == 1 ?? 'bottle' !! 'bottles' }
    method line_one     { "{$.bottles} {$.container} of beer on the wall,"; }
    method line_two     { "{$.bottles} {$.container} of beeeeer,"; }
    method line_three   { return @!line_three.pick ~ ',' }
    method line_four    { 
        $.bottles > 0
            ?? "{$.bottles} {$.container} of beer on the wall."
            !! "No more bottles of beer on the wall ☹";
    }
    method lose_bottle  { $!bottles-- }

    method sing {
        while $.bottles >= 0 {
            say $.line_one();
            say $.line_two();
            say $.line_three();
            say $.line_four();
            say '';
            $.lose_bottle();
        }
    }
}

my $s = Song.new;
$s.sing;

