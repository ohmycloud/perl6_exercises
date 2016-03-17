#!/usr/bin/env perl6


if False {  # Basics #{{{
    
    ### First, create a Promise object and see its status
    my $p1 = Promise.new();
    say "p1 status before keeping: " ~ $p1.status;      # Planned


    ### The Promise itself is kind of amorphous.  We know now that we're 
    ### planning on doing $something in another thread, but nobody knows what 
    ### that $something is yet.


    ### keep() tells our promise what we want to do.  These are legal (pick 
    ### one):
    #$p1.keep('my result');
    $p1.keep( 5 + 3 );


    say "p1 status after keeping: " ~ $p1.status;       # Kept


    ### Here we'll see the result of whatever computation is in the keep() 
    ### call above.
    say "p1 result: " ~ $p1.result;     # 'my result' or '8'
    

}#}}}
if False {  # Breaking a promise# {{{

    my $p = Promise.new;
    say $p.status;                 # Planned
    $p.break('Ruh-roh, raggy!');
    say $p.status;                 # Broken
    #say $p.result;                # dies with "Ruh-roh, raggy!", so commented out.
    ''.say;
        
}# }}}
if False {  # Chaining ## {{{


    ### The tut says:
    ###     Promises gain much of their power by being composable, for example 
    ###     by chaining
    ###
    ### So this section is important.


    ### Create two promises.  The second one depends upon the first one 
    ### completing.
    my $p1 = Promise.new;
    my $p2 = $p1.then(
#            -> $v { say $v.result; "Second Result" }       # works
            -> $v { $v.result ~ " -- Second Result" }       # also works
        );
    $p1.keep("First Result");
    say $p2.result;
    ''.say;

    ### So the second promise gets the first promise object as its arg.

}# }}}
if False {  # Breaking a promise chain# {{{

    ### This time our first promise is going to break.
    my $p1 = Promise.new;
    my $p2 = $p1.then(
        -> $v { say "In p2, attempting to look at p1's result:"; say $v.result }
    );


    ### The then() block assigned to $p2 gets called whenever $p1 is either 
    ### kept _or_ broken.


    ### Calling break() is like calling die() for a specific promise.
    ###
    ### We're demonstrating breaking a promise here, but the commented-out 
    ### keep() line is there so you can compare the difference between a 
    ### broken and non-broken promise.  
    ###
    ### After seeing how the break() behaves, come back and switch the 
    ### comments to see how the keep() behaves.
    $p1.break("This is p1 breaking.");
    #$p1.keep("This is p1 working.");


    ### Since $p2 depends on $p1, and $p1 broke, uncommenting this results in 
    ### an exception that halts the program.
    #say $p2.result;


    ### Instead of just printing $p2's result, we can try it.
    ###
    ### Remember to test for $! before trying to print it out!  If our try 
    ### succeeded, $! will be false, so just trying to print it 
    ### unconditionally will result in an exception if the try succeeded 
    ### (which is wildly backwards from what you're trying to avoid with try):
    try $p2.result;
    say "--$!--" if $!;


    ### At ths point, we have this output:
    ###     In p2, attempting to look at p1's result:
    ###     --This is p1 breaking.--
    ### 
    ### p2's then() block is attempting to:
    ###     say $v.result;
    ### That produces no output since $v (aliased to $p1) is a broken promise.



    ### If $p1 broke, $p2's status will be "Broken".  If $p1 did not break, 
    ### $p2's status will be "Kept".
    say $p2.status;

    ### If $p2 is listed as Broken, calling its .cause method will tell you 
    ### why it broke.
    if $p2.status eq 'Broken' {
        say "Cause: " ~ $p2.cause;      # "This is p1 breaking"
    }

}## }}}
if False {  # Keep a promise in the future# {{{

    ### Promise.in() schedules the promise to be run ("kept") at a future 
    ### time.

    my $p1 = Promise.in(2);     # 2 seconds
    my $p2 = $p1.then(-> $v {say $v.status; 'Second Result'} );
    say "before";
    say $p2.result;     # blocks for 2 seconds before producing output
    say "after";

}# }}}
if False {  # The start and await shortcuts  # {{{


    ### Instead of creating a promise and then assigning it code with keep(), 
    ### requiring two separate steps, we can just use the start() shortcut:
    my $p1 = Promise.start({ my $var = 1 + 3 });
    say "p1 was kept successfully and returned: " ~ $p1.result;     # 4
    ''.say;


    ### Here's start() with a broken promise
    my $p2 = Promise.start({ die "die() will break a promise." });
    try $p2.result;
    if $p2.status eq 'Broken' {
        say "--{$p2.cause}--";      # --die() will break a promise--
    }
    ''.say;
    

    ### The Promise.start method is common enough that 'start' is provided as 
    ### a subroutine.
    my $p3 = start { my $var = 4 * 3; };
    say "p3's result: " ~ $p3.result;
    ''.say;


    ### await() is very much like calling .result on a promise.
    my $p4 = start { my $var = 4 * 3; };
    my $r4 = await $p4;
    say "p4's result after the await call: $r4";
    ''.say;

    ### The advantage to await() is that it can take a list of promises, and 
    ### return the result of each as a list.
    my $p5 = start { my $var = 2 * 3 };
    my $p6 = start { my $var = 4 * 5 };
    my @r4 = await $p5, $p6;
    say @r4;                            # [6 20]

}# }}}
if False {  # Slightly more RL example    # {{{


    ### So far, the examples have been purely academic and not very useful.


    ### Here, we have a function that pretends to read a file and parse it 
    ### from JSON.  We'll assume the process takes 2 seconds.
    sub parse_json_file(Str $filename) {
        sleep 2;
        return 'json result';
    }




    ### So if we parse out two JSON files sequentially....
    my $before = DateTime.now;
    my $json_one = parse_json_file('file_one');
    my $json_two = parse_json_file('file_two');

    say $json_one eqv $json_two
        ?? "The two files are identical."
        !! "The two files are different.";

    my $after = DateTime.now;
    say "that took {$after.second - $before.second} seconds.";
    ### ...then that's clearly going to take just over 4 seconds.




    ### Instead, run those parses as promises so they run in parallel:
    $before = DateTime.now;
    my $parsing_one = start parse_json_file('file_one');
    my $parsing_two = start parse_json_file('file_two');

    my ($parallel_json_one, $parallel_json_two) = await $parsing_one, $parsing_two;

    say $parallel_json_one eqv $parallel_json_two
        ?? "The two files are identical."
        !! "The two files are different.";

    $after = DateTime.now;
    say "that took {$after.second - $before.second} seconds.";
    ### And now we're back to taking only just over 2 seconds, since the two 
    ### parsing runs ran in parallel.

}# }}}
if False {  # anyof, allof#{{{


    ### allof() returns a new promise, which is kept only when all of its 
    ### components are kept or broken.
    ###
    ### anyof() returns a new promise that's kept when (you guessed it) any of 
    ### its components are kept or broken.


    ### Here, p1 and p2 are both kept, and p3 ends up being True.
    my $p1 = Promise.start({ my $var = 2 + 2 });
    my $p2 = Promise.start({ my $var = 3 + 3 });
    my $p3 = Promise.allof( $p1, $p2 );
    my $r3 = await $p3;
    say "Result of p1: {$p1.result}";       # 4
    say "Result of p2: {$p2.result}";       # 6
    say "Result of p3: $r3";                # True, since p1 and p2 were both kept.
    ''.say;


    ### Here, p4 is kept, but p5 is broken.  p6 still ends up True.
    my $p4 = Promise.start({ my $var = 2 + 2 });
    my $p5 = Promise.start({ die "p5 broke." });
    my $p6 = Promise.allof( $p4, $p5 );
    my $r6 = await $p6;

    say "p4 status: " ~ $p4.status;         # Kept
    say "p5 status: " ~ $p5.status;         # Broken

    ### Remember that allof() does NOT require that all of its components be 
    ### kept.  What it does is wait until all of its components are complete, 
    ### whether their status is Kept or Broken. 
    say "Result of p6: $r6";                # True
    ''.say;



    ### anyof() returns true as soon as any of its components complete.
    ###
    ### Go ahead and leave p8 at a big number here - you're not going to have 
    ### to wait it out.
    my $p7  = Promise.in(2);
    my $p8  = Promise.in(100000);
    my $p9  = Promise.anyof( $p7, $p8 );

    my $start   = DateTime.now;
    my $r9      = await $p9;
    my $end     = DateTime.now;

    ### This produces output (and the script ends) as soon as p7 completes.
    ###
    ### This is because we're not specifically await()ing p8.  
    say "The anyof promise took {$end.second - $start.second} seconds.";        # about 2

}#}}}
if False {  # vow  #{{{

    ### If you've got a promise that you're going to hand back to userland 
    ### code, but which you do not want userland code to either keep or break, 
    ### you can create a vow.
    ###
    ### Once created, the Vow object is the only mechanism that can either 
    ### keep or break the promise.

    my $p1 = Promise.new();
    my $v1 = $p1.vow;
    #$p1.keep("foo");       # GONNNG - the promise can't call keep() once the vow has been created.
    $v1.keep("foo");        # ...but the vow can call keep().
    say $p1.result;


    ### So the point is that your class/sub/whatever returns the promise back 
    ### to its caller.  That promise can be inspected and poked at, but it 
    ### cannot be kept.
    ###
    ### Your class/sub/whatever holds onto the Vow, and uses that to keep the 
    ### promise when it's appropriate.





    ### So here's a kind of bogus example of the above.  Our promise can only 
    ### be kept by the vow inside our get_promise() routine.
    sub get_promise {
        my $p1 = Promise.new();
        my $v1 = $p1.vow;
        Promise.in(2).then({ $v1.keep("foobar") });
        return $p1;
    }
    my $p2 = get_promise();
    #$p2.keep("blargle");   # Access denied to keep/break this Promise; already vowed
    say $p2.result;         # Blocks for the 2 seconds from the in(), then produces "foobar".

}#}}}


