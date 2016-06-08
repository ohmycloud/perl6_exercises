#!/usr/bin/env perl6 


### Timer results bottom this file.


class FileBuffer {
    has Int         $.chunksize;
    has Int         $.max_read;
    has IO::Path    $.file;
    has IO::Handle  $.fh;
    has Bool        $.done;
    has Str         @.lines;

    has $.channel;

    submethod BUILD(Int :$chunksize = 10, Str :$file) {
        $!chunksize = $chunksize;
        $!max_read  = $!chunksize * 10;
        $!file      = $file.IO;
        $!fh        = open $!file;
        $!done      = False;

        $!channel   = Channel.new;

    }

    method get() {
        while $.fh.opened {
            my @lines = grep { .WHAT ~~ Str }, $.fh.get xx $.max_read;
            while @lines.elems {
                if @lines.elems <= $.chunksize and $.fh.opened {
                    @lines.append( grep { .WHAT ~~ Str }, $.fh.get xx $.max_read );
                    $.fh.close if $.fh.eof;
                }


                ### I need to send $.chunksize records out over the channel.
                ### I then need to remove those records from the @lines array.
                ###
                ### I've tried 3 different methods of doing that.  Comments on 
                ### the speed of each are bottom this file.



                ### loop/splice
                ### Send a certain number of @lines, then splice out the 
                ### @lines we just sent.  Differs from the other splice 
                ### attempt because this is resizing @lines from the end.
                #loop ( my $i = 0; $i < $.chunksize; $i++ ){
                #    last unless defined @lines[$i];
                #    $.channel.send( @lines[$i] );
                #}
                #@lines = splice @lines, $.chunksize;
                
                ### splice
                ### out the lines to send.  I think this is slow because it's 
                ### resizing @lines from the front.
                my @send = splice @lines, 0, $.chunksize;
                for @send -> $r {
                    $.channel.send( $r );
                }

                ### shift
                ### Just shift off one rec at a time from @lines.
                ### This seems to me like it should be slow since it's 
                ### resizing @lines each time, but it's as fast as anything 
                ### else.  I suppose shift may be more optimized than splicing 
                ### an arbitrary number from the front.
                #$.channel.send( shift @lines );
            }
            $.channel.close;
        }
    }
}


my $fb  = FileBuffer.new( :file('data.txt'), :chunksize(1000) );

my $start = now;
$fb.get;
my @promises;
for 1..48 -> $n {
    @promises.push( Promise.start({process_records($fb, $n)}) );
}
await @promises;
say "that took {now - $start} seconds.";


sub process_records($fb, Int $n) {

    ### For whatever reason, chdir first works ok...
    chdir "/home/jon/work/rakudo/projects/process_file_in_chunks/out_channel";
    my $fh = open "{$n}.txt", :w;
        ### This still blows up sometimes.  And the output files are still 
        ### occasionally corrupt.  I dunno why.

    


    ### ...but attempting to open the files with a path like this bombs out 
    ### eventually.  Maybe the threads' CWD is not necessarily ./ ?
    #my $fh = open "out_channel/{$n}.txt", :w;

    ### I originally tried opening the output files in the for loop that's 
    ### creating the promises above, and passing the handles in here, but that 
    ### also eventually bombs out (SIGABRT).

    for $fb.channel.list -> $rec {
        $fh.say($rec);
        sleep .01;
    }
}


### 5000 line file, chunksize 1000, .01 sleep

### I don't think the variance below means anything.  I just ran the same 
### version of the script twice in a row with no changes in the code, and got 
### 5.2 secs the first time and 4.6 the next.

###
### shift
###
### 16 promises:    5.1 seconds
### 32 promises:    4.8 seconds
### 128 promises:   4.7 seconds
###
### loop/splice
###
### 16 promises:    5.3 seconds
### 32 promises:    5.3 seconds
### 128 promises:   5.3 seconds
###
### splice
###
### 16 promises:    4.7 seconds
### 32 promises:    4.4 seconds
### 128 promises:   4.8 seconds


