#!/usr/bin/env perl6

#my $base_dir = callframe(0).file.IO.dirname.IO.absolute.IO;
#say $base_dir;
#`{ Yikes on that $base_dir # {{{

    The goal here is to get the absolute (not relative!) path to the directory 
    containing this script, as an IO::Path object.

    callframe(0).file
        Relative path to this file (./test.p6) as a string.
        Tack on ".IO" to turn it into an IO::Path object.

    callframe(0).file.IO.dirname
        Relative path to this file's parent directory ('.') as a string.
        Tack on ".IO" to turn it into an IO::Path object.

    callframe(0).file.IO.dirname.IO.absolute
        Absolute path (this is what I'm going for) as a string.
        Tack on ".IO" to turn it into an IO::Path object.

}# }}}



#|{

The following used:
    $ perl6 -v
    This is Rakudo version 2016.04 built on MoarVM version 2016.04
    implementing Perl 6.c.



$?FILE and .parent seems like the better way to go.  But note that I start 
getting different output depending on how the script was invoked.

The upshot here is that either
        $?FILE.parent.parent
    or
        $?FILE.parent.parent.parent

is what you want for getting the full path to the script's parent directory.  
But it's only useful if you 100% know for sure how the script is going to be 
invoked.  If the user is going to alternate between "./findbin.p6" and "perl6 
findbin.p6", then you're going to have a bad time.

}


### Full path to the current file.
say $?FILE;
#|{
    ./findbin.p6
        /home/jon/work/rakudo/JDB_Common_Howtos/findbin.p6
    perl6 findbin.p6
        /home/jon/work/rakudo/JDB_Common_Howtos/findbin.p6
}

### Full path to current file's parent.
### Fine so far.
say $?FILE.IO.parent;
#|{
    ./findbin.p6
        "/home/jon/work/rakudo/JDB_Common_Howtos".IO
    perl6 findbin.p6
        "/home/jon/work/rakudo/JDB_Common_Howtos".IO
}

### So this should give us the full path to the previous directory, which is 
### generally the $base_dir I'm looking for.
say $?FILE.IO.parent.parent;
#|{
    ./findbin.p6
        "/home/jon/work/rakudo/JDB_Common_Howtos".IO    # WHAT THE FUCKING FUCK?
    perl6 findbin.p6
        "/home/jon/work/rakudo".IO


    That is not a copy/paste error up there.  When invoked with ./findbin.p6:
        $?FILE.IO.parent eq $?FILE.IO.parent.parent

}


### The results of tacking another .parent on the end are pretty predictable 
### now:
say $?FILE.IO.parent.parent.parent;
#|{
    ./findbin.p6
        "/home/jon/work/rakudo".IO
    perl6 findbin.p6
        "/home/jon/work".IO
}







