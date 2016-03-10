#!/usr/bin/env perl6

if False { # Live Supply #{{{

    ### On Supplier adds data to a stream, and multiple consumers can tap into 
    ### that supply.
    ###
    ### This is a sort of multiple-receiver message queue.


    my $supplier    = Supplier.new;
    my $supply      = $supplier.Supply;

    $supply.tap( -> $v { say $v} );
    $supply.tap( -> $v { say "--$v--"} );

    ### emit() passes its args along to each supply tap consecutively.
    for 1..3 {
        $supplier.emit($_);     # Note it's the supplier that emit()s, not the supply.
            ### 1
            ### --1--
            ### 2
            ### --2--
            ### 3
            ### --3--
    }
    ''.say;


    ### I could see this being used in a logging situation.
    ###
    ### The Supplier would emit log messages, and probably levels.
    ###
    ### Multiple consumers could then be set up to tap into that supply.  Some 
    ### consumers would write entries to a file, others to a database, STDERR, 
    ### etc.
    
}#}}}
if False { # On-tap Supply#{{{

    ### Instead of first creating a Supplier factory as we did for the live 
    ### supply, an on-tap supply is created using the supply keyword:
    my $supply = supply {
        for 1..3 {
            emit($_);
        }
    }

    ### In this case, all of the code in the supply{} block is executed each 
    ### time the supply is tapped.
    $supply.tap( -> $v { say "First: $v" });
    $supply.tap( -> $v { say "Second: $v" });
        ### First: 1
        ### First: 2
        ### First: 3
        ### Second: 1
        ### Second: 2
        ### Second: 3
    ''.say;
}#}}}
if False { # The tap method and object #{{{
    
    ### tap() returns a tap object.

    my $supplier    = Supplier.new;
    my $supply      = $supplier.Supply;

    my $tap = $supply.tap( -> $v { say $v });

    $supplier.emit("Tap is open, so this will emit.");

    $tap.close;                 # turn off the tap

    $supplier.emit("this will not emit since the tap is off.");

    ''.say;
}#}}}
if False { # .interval(), .react() (code commented out just to avoid delays) #{{{

    ### interval() returns an on-demand supply that emits every N seconds.
    ###
    ### The arg passed to tap() is an integer, starting from 0 and 
    ### incrementing;

    my $supply  = Supply.interval(2);
    my $tap     = $supply.tap( -> $v { say "Interval: $v"} );
    sleep 6;
    ### Output, with 2 seconds between each line:
    ###     0
    ###     1
    ###     2
    ''.say;

    ### If we don't close the interval tap, it'll continue to produce output 
    ### during the react example code below.
    ###
    ### Comment this close line out to see the effect.
    $tap.close;
        


    ### The same thing can be accomplished using react.  "whenever" creates 
    ### our tap.  But we don't need to save that tap and then close it -- 
    ### instead, we can call done() when we want the thing to shut down.
    react {
        whenever Supply.interval(2) -> $v {
            say "React: $v";
            done() if $v == 2;
        }
    }

    say "sleeping two more seconds to ensure that the react finished at 2:";
    sleep 2;
    say "Done sleeping.";
    
    ''.say;
}#}}}
if False { # grep#{{{

    ### grep filters

    my $supplier = Supplier.new;


    ### This is our main supply.  It's not filtered in any way and just always 
    ### outputs.
    my $supply = $supplier.Supply;
    $supply.tap( -> $v { say "Original: $v" });


    ### Create a second supply by grep'ing the main supply for odd output.
    my $odd_supply = $supply.grep({ $_ % 2 });
    $odd_supply.tap( -> $v { say "Odd: $v" });


    ### The third supply is the same idea, just going for even output.
    my $even_supply = $supply.grep({ not $_ % 2 });
    $even_supply.tap( -> $v { say "Even: $v" });


    ### This last supply is identical to the main one, but its output happens 
    ### at the end, so you can see that _when_ a supply is created does affect 
    ### output order.
    my $separator = $supplier.Supply;
    $separator.tap( -> $v { say "-------" });


    for 0..5 {
        $supplier.emit($_);
    }

    '----------------------------'.say;




    ### I originally tried organizing my code like this, because I like 
    ### grouping things.
    ###
    ### But what's happening is that Odd and Even aren't printing in the right 
    ### places.
    ###
    ### Whichever one of $odd_supply and $even_supply is created SECOND 
    ### determines where in the output both taps appear.
    say '';
    say "Out of order code follows.";
    say '';

    my $supplier2    = Supplier.new;
    my $supply2      = $supplier2.Supply;
    my $separator2   = $supplier2.Supply;

    ### Run this multiple times, twiddling the order of these next two lines 
    ### each time to see the differences.
    ###
    ### ...the more I look at this, the more I think it's a stupid thing to 
    ### bother having in these notes.  Of course it's working this way.
    my $odd_supply2  = $supply2.grep({ say "-$_-"; $_ % 2 });
    my $even_supply2 = $supply2.grep({ say "=$_-"; not $_ % 2 });

    ### NYI
    ### The "say"s that I added show that the supply2 grep'd most recently 
    ### completely overrides the previous one.
    ###
    ### Unclear if this is How It Works or if it's an implementation bug.

    $supply2.tap(      -> $v { say "Original: $v" });
    $odd_supply2.tap(  -> $v { say "Odd: $v" });
    $even_supply2.tap( -> $v { say "Even: $v" });
    $separator2.tap(   -> $v { say "-------" });

    for 0..5 {
        $supplier2.emit($_);
    }

}#}}}
if True { # map #{{{

    ### where grep filters, map transforms

    my $supplier = Supplier.new;

    my $supply = $supplier.Supply;
    $supply.tap( -> $v { say "Original: $v" });

    my $half_supply = $supply.map({ $_ / 2 });
    $half_supply.tap( -> $v { say "Half: $v" });

    for 0..5 {
        $supplier.emit($_);
    }
}#}}}

