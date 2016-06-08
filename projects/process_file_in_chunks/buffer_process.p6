#!/usr/bin/env perl6 

### Timer results bottom this file.

#|{
    Meant to read large files.

    get() returns a certain number of lines from the file each time.  The last 
    iteration may contain fewer than that given number.

    Logic:
        $chunksize is the number of lines the user wants returned each time.
        $max_read is how many lines to read from the file at a time.
            Currently that's being set to 10 times larger than whatever 
            $chunksize the user requested.  That's a bit naive.

        When get() is called:
            - Return bool False if we're already finished with everything.

            - If our current buffer size is smaller than the chunksize the 
              user requested and we're not finished reading the file yet:

                - Read in $max_read additional lines from the file, and append 
                  those to our buffer.
                    - If we (eg) have 4 lines left in the file, but our 
                      $max_read is set to 10, the last 6 lines read will be of 
                      type Any.  We just want the four actual Str types, so 
                      grep out the Anys.
                    - If we've reached EOF, close the file.

            - Our internal buffer should now be larger than the requested 
              chunksize if the file is not empty yet.  If that's not the case, 
              we know the file _is_ empty, and the chunk of lines we're about 
              to return is the last chunk - there's nothing left.
                - So set $!done to True.

            - Return the first $chunksize lines out of our internal buffer.

}
class FileBuffer {
    has Int         $.chunksize;
    has Int         $.max_read;
    has IO::Path    $.file;
    has IO::Handle  $.fh;
    has Bool        $.done;
    has Str         @.lines;

    submethod BUILD(Int :$chunksize = 10, Str :$file) {
        $!chunksize = $chunksize;
        $!max_read  = $!chunksize * 10;
        $!file      = $file.IO;
        $!fh        = open $!file;
        $!done      = False;
    }

    method get() {
        return False if $.done;
        if @.lines.elems <= $.chunksize and $.fh.opened {
            @.lines.append( grep { .WHAT ~~ Str }, $.fh.get xx $.max_read );    # append, not push
            $.fh.close if $.fh.eof;
        }
        $!done = True if @.lines.elems <= $.chunksize;
        return @.lines.splice(0, $.chunksize);
    }
}


my $fb  = FileBuffer.new( :file('data.txt'), :chunksize(1000) );
my $ofh = open 'output.txt', :w;

my $start = now;
while not $fb.done {
    my @rows = $fb.get();

    for @rows.race( batch => 128 ) -> $rec {
        process_record($rec, $ofh);
        sleep .01
    }
}
say "that took {now - $start} seconds.";

sub process_record(Str $rec, IO::Handle $fh) { $fh.say($rec); }


###
### 5,000 line file, chunksize 1000, .01 sec sleep during process_record
###
### with race, 128 batch:   13 seconds
### with race, 64 batch:    13 seconds
### with race, 32 batch:    13 seconds
### with race, 16 batch:    seconds
### with race,  8 batch:    seconds
### with race,  4 batch:    seconds
### with race,  2 batch:    seconds
### with race,  1 batch:    seconds


###
### 5,000 line file, chunksize 100, .01 sec sleep during process_record
###
### with race, 64 batch:    33 seconds
### with race, 32 batch:    16 seconds
### with race, 16 batch:    16 seconds
### with race,  8 batch:    14 seconds
### with race,  4 batch:    14 seconds
### with race,  2 batch:    13 seconds
### with race,  1 batch:    13 seconds


###
### 1000 line file, chunksize 10, .1 sec sleep during process_record
###
### without race:           didn't bother, it's going to take 100 seconds.
### with race, 64 batch:    10 seconds
### with race, 32 batch:    10 seconds
### with race, 16 batch:    10 seconds
### with race,  8 batch:    8 seconds
### with race,  4 batch:    4 seconds
### with race,  2 batch:    4 seconds
### with race,  1 batch:    3 seconds

###
### 1000 line file, chunksize 100, .1 sec sleep during process_record
###
### without race:           didn't bother, it's going to take 100 seconds.
### with race, 64 batch:    6.4 seconds
### with race, 32 batch:    3.2 seconds
### with race, 16 batch:    3.2 seconds
### with race,  8 batch:    2.8 seconds
### with race,  4 batch:    2.8 seconds
### with race,  2 batch:    2.6 seconds
### with race,  1 batch:    2.5 seconds







