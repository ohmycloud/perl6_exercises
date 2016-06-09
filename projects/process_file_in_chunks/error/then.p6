#!/usr/bin/env perl6 

use v6;




### Shit I just realized I had 2016-04 set in my PATH rather than 2016-05.
###
### Backing up to ./small.p6 to check that.




### Here I'm trying to break up the operations into three different promises.



=begin foo

Most of the time, one "file open" produces an error.  But occasionally, two of 
them will error.

When I get two open errors, here's the output, including the debug stuff:

    18 -- output/18.txt
    17 -- output/17.txt
    Handled: False
    Handled: False
    Exception: Failed to open file /home/jon/work/rakudo/projects/process_file_in_chunks/error/output/17.txt: no such file or directory
    Exception: Failed to open file /home/jon/work/rakudo/projects/process_file_in_chunks/error/output/17.txt: no such file or directory
    Failure

Some things to note:
    - The files that broke were 17.txt and 18.txt.
    - Both lines of Exception mention 17.txt.  No Exception mentions 18.
    - $fh.WHO ("Failure") only gets printed out once (that's not a copy/paste 
      error).

It's possible that the repeated Exception text is just IO weirdness with fish 
shell or my terminal or perl6 or whatever.  Same with the single output of 
"Failure".  BUT it seems more likely that this is part and parcel of the 
error.




I just tried again until I got another pair of errors in a single run:

    5 -- output/5.txt
    7 -- output/7.txt
    Handled: False
    Handled: False
    Exception: Failed to open file /home/jon/work/rakudo/projects/process_file_in_chunks/error/output/7.txt: no such file or directory
    Exception: Failed to open file /home/jon/work/rakudo/projects/process_file_in_chunks/error/output/7.txt: no such file or directory
    Failure
    Failure

OK, here we have "Failure" being displayed twice.  But the Exception text is 
still duplicated, and it's not duplicated for the first file this time, but 
the second.

http://s2.quickmeme.com/img/c1/c17071d4c09814be4e215bea6fdee068ebb76f5634d00c132a9370f43f6b84fe.jpg



=end foo



sub create_file(Int $n) {
    my $fn = "output/{$n}.txt";
    my $fh = open $fn, :w;
    unless $fh ~~ IO::Handle {
        say "$n -- $fn";
        say "Handled: {$fh.handled}";
        say "Exception: {$fh.exception}";
        say $fh.WHO;
        exit;
    }
}
sub process_records(Int $n) {
    my $fh = open "output/{$n}.txt", :w;
    $fh.say("--$n--");
    return $fh;
}
sub close_file($fh) {
    close $fh;
}



my $in_file     = 'data.txt'.IO;
my $max_writers = 40;

my @promises;
for 1..$max_writers -> $n {
    my $fh;

    my $p1 = Promise.start({ create_file($n) });
    my $p2 = $p1.then({ $fh = process_records($n) });

    ### If I do this and then comment out all following code, I end up with 
    ### the same error I've been getting.  Even with no "close" hitting.
    @promises.push( $p2 );


    ### But if I do this, the script works most of the time.  When it doesn't 
    ### work, I get:
    ###     No such method 'close' for invocant of type 'Any'
    #my $p3 = $p2.then({ close_file($fh) });
    #@promises.push( $p3 );
}
await @promises;

