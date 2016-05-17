#!/usr/bin/env perl6

use v6;
use NativeCall;


### There's no fork() in p6.  It's normally not needed since p6 gives us a 
### bunch of other ways to do concurrency.
###
### But if you really want it, you just use fork() from the standard library.




### "is native" here has no arguments.  That means that the function (fork) 
### we're trying to access comes from the standard library.
###
###
### "$ man 2 fork" tells us that fork() uses this signature
###     pid_t fork(void)
### so it takes no arguments and returns "pid_t".  
###
### Figuring out what data type "pid_t" is takes a little digging, but if you 
### google for "what data type is pid_t returned by fork", you'll find that 
### pid_t is a C int.
### 
### This table:
###     http://docs.perl6.org/language/nativecall#Passing_and_Returning_Values
### tells us that a C int is represented in p6 as "int32", which is how we got 
### the "returns int32" below.
sub fork() returns int32 is native {};




given fork() {
    when 0     { say "I'm a kid!";                      };
    when * > 0 { say "I'm a parent. The kid is at $_";  };
    default    { die "Failed :(";                       };
}

sleep .5;
say 'Hello, World!';

