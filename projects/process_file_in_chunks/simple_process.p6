#!/usr/bin/env perl6 


my $ifh = open 'data.txt';
my $ofh = open 'output/simple_process.txt', :w;

my $start = now;
for $ifh.lines -> $line {
#for $ifh.lines.race(batch => 16) -> $line {
    process_record($line, $ofh);
}
say "that took {now - $start} seconds.";


sub process_record(Str $rec, IO::Handle $fh) {
    my $out = (map { fizzbuzz($_.Int) }, [$rec.split(',')]).join(',');


    ### More funk.  say() should work fine.  But when it's in use, sometimes 
    ### the newline gets misplaced.  We still end up with the right amount of 
    ### data and the right number of lines, but it looks like this:
    ###     out
    ###     out
    ###     outout
    ###
    ###     out
    ###     out
    ### ...where "out" should appear once on each line.
    ###
    ### Simply using "print" with a newline fixes this.

    $fh.print("$out\n");
    #$fh.say($out);
}
sub fizzbuzz(Int $n) returns Str {# {{{
    return 'fizzbuzz' unless $n % 15;
    return 'buzz' unless $n % 5;
    return 'fizz' unless $n % 3;
    return $n.Str;
}# }}}


###
### 5,000 line file, .01 sec sleep during process_record
###
### no race:                51 seconds
###     more or less as expected - 5000 lines * .01 sleep per line == 50 seconds.
### with race, 64 batch:    13 seconds
### with race, 32 batch:    13 seconds
### with race, 16 batch:    13 seconds
### with race,  8 batch:    13 seconds
### with race,  4 batch:    13 seconds
### with race,  2 batch:    13 seconds
### with race,  1 batch:    13 seconds


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




