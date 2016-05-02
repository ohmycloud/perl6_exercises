#!/usr/bin/env perl6

my @words = read_file('text.txt');


#|{
    Returns an AoA.
            @lines = [
                [words on line 1],
                [words on line 2],
                [words on line N],
            ]
}
sub read_file ($f) {
    my @words;
    for $f.IO.lines -> $l {
        @words.push( $l.split('$') );
    }
    return @words;
}


