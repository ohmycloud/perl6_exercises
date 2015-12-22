#!/home/jon/.rakudobrew/bin/perl6

{ # Basics #{{{
    

my $p1 = Promise.new;
say $p1.status;             # Planned
$p1.keep('my result');
say $p1.status;             # Kept
say $p1.result;             # my result
say $p1.result;             # my result (so you can use .result more than once.)
''.say;

my $p2 = Promise.new;
say $p2.status;                 # Planned
$p2.break('Ruh-roh, raggy!');
say $p2.status;                 # Broken
#say $p2.result;                # dies with "Ruh-roh, raggy!", so commented out.
''.say;

}#}}}
{ # Chaining #{{{

### This is composed "backwards", but the output is:
###     First Result
###     Second Result
my $p1 = Promise.new;
my $p2 = $p1.then(
        -> $v { say $v.result; "Second Result" }
    );
$p1.keep("First Result");
say $p2.result;
''.say;


### This is the same idea, but this time, our first promise is going to break.
my $p3 = Promise.new;
my $p4 = $p3.then(
    -> $v { say "Handled, but:"; say $v.result }
);

$p3.break("This is the first promise breaking.");

### Output:
###     Handled, but:
try $p4.result;

### Output:
###     This is the first promise breaking.
###       in block at ./test.p6:41          (41 is the line the 'try' appears on)
###       in block <unit> at ./test.p6:17   (17 is the line my # Chaining
###                                          block starts on.)
say $p4.cause;


### Promise.in() schedules the promise to be run ("kept") at a future time.
my $p5 = Promise.in(2);     # 2 seconds
my $p6 = $p5.then(-> $v {say $v.status; 'Second Result'} );
say "before";
say $p6.result;     # blocks for 5 seconds before producing output
say "after";
''.say;




}#}}}
{ # start #{{{

### The start method is a shortcut.  I'm a little unclear how this is 
### different from keep at this point.
my $p1 = Promise.start({ my $var = 1 + 3 });
say $p1.result; # 4

### And here's start() with a broken promise
my $p2 = Promise.start({ die "Broken promise" });
try $p2.result;
say $p2.cause;
    

### The docs say that this start is very common.  Enough so that start is 
### provided as a subroutine, along with await.
my $p3 = start { my $var = 4 * 3; };
my $r3 = await $p3;
say $r3;
''.say;

    ### NOTE NYI
    ### The code using 'start' above works just fine.
    ###
    ### The docs state that start is provided "as a subroutine".  But note 
    ### that in the working code above, there are no parens:
    ###         start { ...code... };
    ###     ...rather than...
    ###         start( { ...code... } );
    ### 
    ### If you include those parens, p6 produces an "Undeclared routine" 
    ### exception at compile time.
    ###
    ### I'm fine with not using the parens, but not being allowed to use them 
    ### seems strange.



### await is almost the same as calling result on the promise object.  The 
### difference is that await can take a list of promises, and return the 
### result of each as a list.
my $p4 = start { my $var = 2 * 3 };
my $p5 = start { my $var = 4 * 5 };
my @r4 = await $p4, $p5;
say @r4;                            # [6 20]

}#}}}
{ # anyof, allof#{{{

### allof returns a new promise, which is kept only if ALL of its component 
### promises were kept.
my $p6 = Promise.start({ my $var = 2 + 2 });
my $p7 = Promise.start({ my $var = 3 + 3 });
my $p8 = Promise.allof( $p6, $p7 );
my $r8 = await $p8;
say $r8;                # True

my $p9 = Promise.start({ my $var = 2 + 2 });
my $p10 = Promise.start({ die "p10 broke." });
my $p11 = Promise.allof( $p9, $p10 );
#my $r11 = await $p11;  # If uncommented, this dies with "p10 broke."
''.say;


### anyof returns a new promise which is kept if ANY of its component promises 
### were kept.
###
### Here, we don't need to comment out the await call.  Even though one of our 
### promises breaks, the other one does not, and allof only requires that one 
### component works.
my $p12 = Promise.start({ my $var = 2 + 2 });
my $p13 = Promise.start({ die "p13 broke." });
my $p14 = Promise.anyof( $p12, $p13 );
my $r14 = await $p14;
say $r14;       # True
''.say;

}#}}}
{ # vow#{{{

### If you've got a promise that you're going to hand back to userland code, 
### but which you do not want userland code to either keep or break, you can 
### create a vow.
###
### Once created, the vow is the only mechanism that can either keep or break 
### the promise.

my $p1 = Promise.new();
my $v1 = $p1.vow;
#$p1.keep("foo");       # GONNNG - the promise can't call keep() once the vow has been created.
$v1.keep("foo");        # ...but the vow can call keep().
say $p1.result;


### So here's a kind of bogus example of the above.  Our promise can only be 
### kept by the vow inside our get_promise() routine.
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

