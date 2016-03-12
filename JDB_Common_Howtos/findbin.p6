#!/usr/bin/env perl6

my $base_dir = callframe(0).file.IO.dirname.IO.absolute.IO;
say $base_dir;

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

