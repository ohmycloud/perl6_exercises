#!/home/jon/.rakudobrew/bin/perl6


### JWorthington's Video {

    ### Asynchrony
    if True {
        ### Another fake sub that pretends to scp a bunch of files across our 
        ### network using the 'scp' in our PATH.

        my $start = DateTime.now.second.Int;

        my @files = <file_one file_two file_three file_four>;

        my @working;
        for @files -> $file {
            my $target = $file ~ ".new";

            ### Here's the command we're pretending to run.
            #my $proc = Proc::Async.new( 'scp', $file, $target );

            ### But since I don't want to actually scp anything anywhere, 
            ### here's what we'll really run.  Pretend it's performing the 
            ### scp.  Each copy is going to take 1-3 seconds.
            ###
            ### Note this is the system's sleep being called, not Perl 6's.
            my $proc = Proc::Async.new( 'sleep', 3.rand.Int + 1 );



            ### Proc.Async returns a promise.
            ###
            ### BUT, if we just await each promise as we iterate our list of 
            ### files, this block will still take 1-3 seconds per file.  So we 
            ### don't want to do this.
            #await $proc.start;


            ### Instead, we'll create an array of promise.starts:
            @working.push($proc.start);
        }

        ### Now, we can await our entire array:
        await @working;
        ### And now our code takes between 1-3 (probably 3) seconds, rather 
        ### than 4-12 seconds, to run.

        my $end = DateTime.now.second.Int;
        say "That took {$end - $start} seconds to run.";
        exit;

    
    }

### }


if False { # Basics #{{{

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
if False { # Write to an external command#{{{

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

