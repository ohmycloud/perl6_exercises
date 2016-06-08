#!/usr/bin/env perl6

if False { # Basics#{{{

    my $channel = Channel.new;
    $channel.send("Channel One");
    say $channel.receive;               # Channel One

    ### The first call to receive() read our message and removed it.  A 
    ### subsequent call to receive() will block until a new message is put 
    ### onto the queue.  In this case, that means that calling receive again 
    ### will block forever.
    ###
    ### Even jamming a try on the front doesn't solve the hang, since it's not 
    ### an error.
    # say $channel.receive;

    ### Close the channel
    $channel.close;

    ### Cannot send a message on a closed channel
    try $channel.send("Won't work; channel has been closed.");  

    ### Cannot receive a message on a closed channel
    try say $channel.receive;

    ''.say;
}#}}}
if False { # Combine a promise with a channel read (list method)#{{{
    
    ### The channel.list method will return all messages currently on the 
    ### channel queue, and then will block, waiting for more messages, unless 
    ### the channel has already been closed.
    ###
    ### We can manage this with a promise.

    my $channel = Channel.new;

    ### This promise syntax is different from what was covered in the Promise 
    ### bit of the tut.  This is creating a promise 10 times.
    ###
    ### Also note that we're not going to sleep (2 * 10) seconds here, or 2 
    ### seconds per each of the 10 iterations.  The promises run concurrently, 
    ### so we'll return to execution after 2 wallclock seconds, even though a 
    ### total of 20 seconds have been slept across all threads.
    ###
    ### ...And "thread" might not be the correct term here.  I'm not sure if 
    ### promises run in separate threads or what.
    await (^10).map: -> $r {
        start {
            sleep 2;
            $channel.send($r);
        }
    }
    $channel.close;


    ### Now that our channel has been closed, we can read off all its items 
    ### using .list() without blocking on the empty channel.
    for $channel.list -> $r {
        say $r;
    }
   
    ''.say;
}#}}}
if False { # .poll(), .closed()#{{{

    ### .poll() is a non-blocking method that returns Nil if the channel is 
    ### empty or even if it's already been closed.

    my $channel = Channel.new;
    $channel.send('One');
    $channel.send('Two');
    $channel.send('Three');

    say $channel.poll;  # One
    say $channel.poll;  # Two
    say $channel.poll;  # Three


    ### .closed() actually returns a Promise that will be kept when the 
    ### channel is closed.  That Promise evaluates to boolean True after the 
    ### channel is closed.


    if not $channel.closed {
        ### The channel is still open, but it's empty, so we get Nil.
        say $channel.poll;  # Nil
    }

    ### The 'Nil' value doesn't cat to a string without complaint.  We can 
    ### print it out on its own as we did above when its value is Nil.  But if 
    ### we try catting that Nil value to a string, we get the warning:
    ###     Use of Nil in string context  in block  at ./channels.p6:96
    ###
    ### So we're using $channel.poll.perl below to avoid that warning.

    $channel.close;
    say "After closing, we get: " ~ $channel.poll.perl;
    if $channel.closed {
        say "It's closed, but we'll try reading from it anyway: " ~ $channel.poll.perl;      # Nil
    }

    ''.say;
}#}}}
if True { # Channel from a Supply#{{{

    ### You can also get a Channel from a Supply.
    ### 
    ### We'll throw in a Promise as well, for good measure.

    my $supplier    = Supplier.new;
    my $supply      = $supplier.Supply;
    my $channel     = $supply.Channel;

    ### Reader
    my $p = start {
        react  {
            whenever $channel -> $item {
                say "via Channel: $item";
            }
        }
    }

    ### Writer
    await (^10).map: -> $r {
        start {
            sleep $r;
            $supplier.emit($r);
        }
    }

    $supplier.done;
    await $p;

}#}}}

