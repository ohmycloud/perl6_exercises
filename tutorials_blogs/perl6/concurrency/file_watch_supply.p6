#!/home/jon/.rakudobrew/bin/perl6

my $dirname = 'file_watch_supply/';


sub watch_all {# {{{


    ###
    ### This sub watches the entire $dirname for any changes.
    ###

    
    ### watch-path() provides a supply that we can tap.

    my $changes = IO::Notification.watch-path($dirname);
    $changes.tap({ say "It changed!" });
    
    ### Now our program can wander off and do something else.
    for 1..10 {
        .say;
        sleep 1;
    }


    ### While this program is running, in another terminal, go into 
    ### ./file_watch_supply/:
    ###
    ### DO NOT GET LAZY AND USE VIM'S FILE MANAGER PLUGIN TO CREATE FILES OR 
    ### EDIT FILES.  Use touch and echo etc on the terminal.  Vim creates swap 
    ### files and changes to those will get counted as well and will confuse 
    ### you.
    ###
    ###     - copy an existing file to a new file
    ###     - delete an existing file
    ###     - edit an existing file (echo 'foo' >> existing.txt)
    ###         This produces 1 line of output.
    ###     - Create a new file (echo 'foo' >> new.txt)
    ###         This produces 2 lines of output.
    ###
    
}# }}}
sub watch_source {      # Does not work.# {{{

    ###
    ### So this is supposed to work like watch_all.  But where watch_all 
    ### reports on any changes made inside our $dirname, this is supposed to 
    ### only look for changes made to .p6 or .pm files.
    ### 
    ### This code does not work because of the warning it produces.
    ###

    my $changes = IO::Notification.watch-path($dirname);


    ### This time, before tapping the supply, set up a grep to only look for 
    ### p6 source files.
    my $code_only = $changes.grep({ *.path ~~ / .pm || .p6 $/ });

    ### That $changes.grep line is from JW's video, but it produces this 
    ### warning:
    ###     WhateverCode object coerced to string (please use .gist or .perl 
    ###     to do that)  in block  at ./file_watch_supply.p6 line 59
    ###
    ### The code then goes on to not work at all, I suspect because of that 
    ### warning.



    $code_only.tap({ say "A source file changed!" });
    for 1..10 {
        .say;
        sleep 1;
    }
    
}# }}}



### The watch_source() sub above requires grep (plus it doesn't work).
###
### If we wanted to use a "regular" loop rather than a grep or a map, we 
### have "whenever", which is essentially an asynchronous for loop.
###
### Whenever can be used in either a supply{} block or a react{} block.
sub watch_source_whenever_supply {# {{{

    ### This does what watch_source() is supposed to do.  It watches our 
    ### $dirname for changes to .p6 or .pm files and reports when it sees 
    ### those changes.

    my $code = supply {
        whenever IO::Notification.watch-path($dirname) {
            emit .path if .path ~~ / .p6 || .pm $/;
        }

        ### This additional whenever block is just to demonstrate that you can 
        ### have as many whenever blocks as you like inside the supply block.
        whenever IO::Notification.watch-path($dirname) {
            emit .path if .path ~~ / .txt $/;
        }
    }
    $code.tap({ say .path ~ " changed!" });

    ### Now our program can wander off and do something else.
    for 1..10 {
        .say;
        sleep 1;
    }

}# }}}
sub watch_source_whenever_react() {# {{{

    ### react is like starting an event loop.  Good for the main loop of your 
    ### program.  (JW)
    ###
    ### You can have as many whenever blocks inside your react block as you 
    ### like.
    ###
    ### Calling done() ends the entire react block.

    react {
        whenever IO::Notification.watch-path($dirname) {
            if .path ~~ / .p6 || .pm $/ {
                say .path ~ " has changed!";
                done();
            }
        }
    }

    say "after react";


}# }}}


#watch_all();
#watch_source();     # doesn't work.
#watch_source_whenever_supply();
watch_source_whenever_react();

