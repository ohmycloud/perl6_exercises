#!/usr/bin/env perl6


### time only gives integer second precision.  And it's "time", not "time()".
say time;
#say time();            # GONNNG!  Undeclared routine.



### an Instant object gets you hires time.
###
### Instant has no new() method though.  It _is_ listed as a class rather than 
### a role, but you can't just instantiate it yourself.
###
### To get an Instant, either just call now (not "now()"!) to get an Instant 
### representing the current time:
my $now = now;
say $now.Rat;
''.say;


### Or create a DateTime object and use its Instant method.  Which would be 
### kinda dumb since you can't specify the instant during the DT constructor, 
### so it's always going to be "NNNNN.0000000".
my $dt = DateTime.new( :year(2016) );
say $dt.Instant.Rat;
''.say;




### Anywho, to time some code:
my $a = now;
{ 'code that you want to time out' };
my $b = now;

say "That took {$b-$a} seconds.";






