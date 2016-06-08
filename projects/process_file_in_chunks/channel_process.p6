#!/usr/bin/env perl6 



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

    has $.supplier;
    has $.supply;
    has $.channel;

    submethod BUILD(Int :$chunksize = 10, Str :$file) {
        $!chunksize = $chunksize;
        $!max_read  = $!chunksize * 10;
        $!file      = $file.IO;
        $!fh        = open $!file;
        $!done      = False;

        
        $!supplier  = Supplier.new;
        $!supply    = $!supplier.Supply;
        $!channel   = $!supply.Channel;

    }

    method get() {
        while ( $.fh.opened ) {
            my @lines = grep { .WHAT ~~ Str }, $.fh.get xx $.max_read;
            await (@lines).map: -> $l {
                start { $.supplier.emit($l); }
            }
            $.fh.close if $.fh.eof;
        }
    }
}


my $fb  = FileBuffer.new( :file('data.txt'), :chunksize(3) );
my $ofh = open 'output.txt', :w;


### Set up the record processor/outputter first.
my $p = start {
    react  {
        whenever $fb.channel -> $record {
            process_record( $record, $ofh );
        }
    }
}

### Now that the reader is prepared to react to changes on the channel, we can 
### start getting records.
my $start = now;
$fb.get();
say "that took {now - $start} seconds.";




sub process_record(Str $rec, IO::Handle $fh) {
    $fh.say($rec);
}


### 100 line file       - that took 0.04614289 seconds.
### 1000 line file      - that took 0.0455532 seconds.
### 1 mill line file    - that took 196.708738 seconds.   (well, shit.)




