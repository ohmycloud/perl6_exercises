#!/usr/bin/env perl6 

my $max_writers = 16;
my $output_dir  = '.';
my $output_file = 'bench_out.txt';
my $chunksize   = 1000;

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
            while @lines.elems {# {{{
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
                #my @send = splice @lines, 0, $.chunksize;
                #for @send -> $r {
                #    $.channel.send( $r );
                #}

                ### shift
                ### Just shift off one rec at a time from @lines.
                ### This seems to me like it should be slow since it's 
                ### resizing @lines each time, but it's as fast as anything 
                ### else.  I suppose shift may be more optimized than splicing 
                ### an arbitrary number from the front.
                $.channel.send( shift @lines );
            }
            $.channel.close;
        }
    }
}
sub create_output_files(Int $num) {# {{{
    ### The output files have to be created non-concurrently before the 
    ### process_records() threads can open them.  The fact that this sub is 
    ### needed seems to be a bug.  See README.
    for 1..$num -> $n {
        my $fh = open "$output_dir/$n.txt", :w;
        $fh.close;
    }
}# }}}# }}}
sub process_records(FileBuffer $fb, Int $num) {# {{{
    my $fn = "{$num}.txt";
    my $fh = open "$output_dir/$fn", :w;

    for $fb.channel.list -> $rec {
        my $out = (map { fizzbuzz($_.Int) }, [$rec.split(',')]).join(',');
        $fh.say($out);
    }

    return [$fn, $fh];
}# }}}
sub combine_output_files(Str $dir, @files) returns Str {# {{{
    chdir $dir;
    my $str = (map { $_[0] }, @files).join(' ');
    my $cmd = "sort -n $str > $output_file";
    shell $cmd;
    return $output_file;
}# }}}
sub dump_temp_files( @files ) {# {{{
    for @files -> $file_array {
        my $rv = $file_array[0].IO.unlink;
    }
}# }}}
sub fizzbuzz(Int $n) returns Str {# {{{
    return 'fizzbuzz' unless $n % 15;
    return 'buzz' unless $n % 5;
    return 'fizz' unless $n % 3;
    return $n.Str;
}# }}}

my $start = now;

say "Getting input file reader";
my $fb  = FileBuffer.new( :file('data.txt'), :$chunksize );

say "Pre-creating output files (this step should be unnecessary)";
create_output_files($max_writers);

say "Processing data into output files";
$fb.get;
my @promises;
for 1..$max_writers -> $n { @promises.push( start {process_records($fb, $n)} ); }
my @files = await @promises;        ### @files is an AoA [ [name, handle], [name, handle], ... ]

say "Joining work files into single output file";
my $output_file_name = combine_output_files($output_dir, @files);

say "Removing work files";
dump_temp_files(@files);

''.say;
say "All records have been processed into $output_file_name.";
say "That took {now - $start} seconds.";

