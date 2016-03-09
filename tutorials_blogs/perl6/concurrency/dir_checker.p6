#!/usr/bin/env perl6


#`{

By defining MAIN like this instead of just starting to write code, we're 
saying that this script must be invoked as:
    $ ./dir_checker.p6 <some_string>

If we send too few or too many arguments, p6 will give us a brief usage 
output:
    $ ./dir_checker.p6
    Usage:
        ./dir_checker.p6 <dirname> 

    $ ./dir_checker.p6 too many arguments
    Usage:
        ./dir_checker.p6 <dirname> 

    $ ./dir_checker.p6 file_watch_supply/
        ...and the program runs as expected...

Neato.



This script watches a directory (name passed on invocation by the user) for 
changes to .p6 and .pm files.  Any change to a file of these types at all will 
be noticed (create a new file, touch an existing file, etc).  

Any change to the directory that doesn't include a file of one of those types 
gets ignored.

EXCEPT if you change a file specifically called "stop.txt", in which case the 
program realizes you're done with it and quits.

#}


sub MAIN(Str $dirname) {
    react {
        whenever IO::Notification.watch-path($dirname) {
            if .path ~~ / .p6 || .pm $/ {
                say "{.path} has changed!";
            }

            if .path ~~ / stop.txt $/ {
                say "Exiting.";
                done();
            }
        }
    }
}

