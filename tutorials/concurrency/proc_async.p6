#!/home/jon/.rakudobrew/bin/perl6

{ # Basics #{{{

    my $proc = Proc::Async.new('echo', 'foo', 'bar');

    $proc.stdout.tap( -> $v { print "Output: $v" });
    $proc.stderr.tap( -> $v { print "Error: $v" });

    ### Calling $proc.start actually runs our external program, returning the 
    ### promise.  Once the external program finishes, our promise will be 
    ### kept.
    say "Starting...";
    my $promise = $proc.start;

    ### So at this point, our external echo hasn't had a chance to finish yet, 
    ### and our promise is still listed as "Planned".  Once our external 
    ### program exits, promise.status will change to "Kept".
    say $promise.status;


        ### My description of the weirdness to follow is probably confusing.  
        ### Just run this program once with this section all commented out, 
        ### then run it again with the lines below uncommented to see the 
        ### difference.

        ### CHECK
        ### 
        ### All of the code in this indented section is "extra" - it was added 
        ### by JDB and is not part of the given example.
        ###
        ### I added the sleep below hoping to show $promise.status afterwards, 
        ### assuming that status would change to 'Kept' after the sleep.
        ###
        ### But what's happening is that our output ("Output: foo bar") is 
        ### appearing on the terminal BEFORE this sleep happens.  And then our 
        ### two rows of hyphens below are printing out together; the 'await' 
        ### produces nothing.
        #sleep 2;

        ### Hell, if I comment out the sleep above, but uncomment this next 
        ### line, I still get the same weirdness.  So displaying 
        ### promise.status once (above) is fine, but doing it twice results in 
        ### this weird output.
        #say $promise.status;


    ### The await call blocks until our external echo actually completes.
    say '-------';
    await $promise;
    say '-------';
    
    ''.say;
}#}}}
{ # Write to an external command#{{{

    ### The ":w" means we're going to write to the command.
    ###
    ### So the command here is to "grep for foo".  We're going to supply the 
    ### text to grep by writing that text.
    my $proc = Proc::Async.new(:w, 'grep', 'foo');
    $proc.stdout.tap( -> $v { print "Output: $v" });

    say "Starting...";
    my $promise = $proc.start;

    ### And here we'll write a couple lines of text to our process.
    $proc.say("This line contains 'foo'.");
    $proc.say("This one does not.");

    ### Tell our process we're finished writing to it, and look for its 
    ### results.
    $proc.close-stdin;
    await $promise;
    say "Done.";


    ''.say;
}#}}}

