#!/usr/bin/env perl6 


my $ifh = open 'data.txt';
my $ofh = open 'output.txt', :w;

my $start = now;
#for $ifh.lines -> $line {
for $ifh.lines.race(batch => 1) -> $line {
    process_record($line, $ofh);
}
say "that took {now - $start} seconds.";


sub process_record(Str $rec, IO::Handle $fh) {
    $fh.say($rec);
    sleep .1
}


###
### 500,000 line file, .1 sec sleep during process_record
###
### with race, 64 batch:    seconds
### with race, 32 batch:    seconds
### with race, 16 batch:    seconds
### with race,  8 batch:    seconds
### with race,  4 batch:    seconds
### with race,  2 batch:    seconds
### with race,  1 batch:    seconds


###
### 1000 line file, .1 sec sleep during process_record
###

### without race:           didn't bother, it's going to take 100 seconds.
### with race, 64 batch:    6.4 seconds
### with race, 32 batch:    3.2 seconds
### with race, 16 batch:    3.2 seconds
### with race,  8 batch:    2.8 seconds
### with race,  4 batch:    2.8 seconds
### with race,  2 batch:    2.6 seconds
### with race,  1 batch:    2.5 seconds


###
### 100 line file, .5 sec sleep during process_record
###

### without race:           50 seconds (as expected)
### with race, 64 batch:    32 seconds
### with race, 32 batch:    16 seconds
### with race, 16 batch:    16 seconds
### with race,  8 batch:    14 seconds
### with race,  4 batch:    14 seconds
### with race,  2 batch:    13 seconds
### with race,  1 batch:    13 seconds




