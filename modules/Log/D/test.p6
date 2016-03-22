#!/usr/bin/env perl6

use Log::D;


my $l = Log::D.new(:w, :i);         # enable warnings and infos    

### Set up the format of the "prefix" - the stuff that appears before the log 
### message.
$l.prefix = sub {
    callframe(2).file ~ " " 
    ~ callframe(2).line ~ " " 
    ~ $*THREAD.id ~ " " 
    ~ DateTime.now ~ " ";
};


$l.enable(:v);                      # also enable verbose, after the fact.


### Just plain messages with no class.
$l.v("This is verbose.");
$l.i("This is info.");
$l.w("This is a warning.");


### Reports all calls to allow(), remove_allow, ban(), etc to the log.
### We're going to make those calls below.
$l.notify = True;


### Allow messages of one class but not another.
###
### At least one class MUST be allowed.  If you comment out the allow() here, 
### the "Other Log Class" log message _will_ get displayed, even if its class 
### is in remove_allow().
$l.allow("Some Log Class");
$l.remove_allow("Other Log Class");
$l.i("Other Log Class", "Some info");


### However, if nothing is allowed, you can ban() a class to force its log 
### messages to not display.
$l.remove_allow("Some Log Class");
$l.ban("Other Log Class");
$l.i("Other Log Class", "This will never be output because it's been banned.");


### Bullshit.  With everything else commented out EXCEPT the remove_ban(), the 
### following log entry does NOT get displayed.
###
### After removing the ban, I have to re-call allow() on the class.  It 
### doesn't matter what else is allowed or not allowed; re-allowing the 
### previously banned class is required.
###
### I think this is a bug.
$l.remove_ban("Other Log Class");
$l.allow("Other Log Class");
$l.i("Other Log Class", "This will be output because we removed the ban.");


