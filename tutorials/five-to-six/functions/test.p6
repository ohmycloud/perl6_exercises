#!/home/jon/.rakudobrew/bin/perl6


### File tests
###
my $fname = 'test.txt';

### path
if $fname.IO ~~ :e { say "File exists."; }
if $fname.IO ~~ :r { say "File is readable."; }

### handle
my $fh = open $fname, :r;
if $fh.r { say "Filehandle is readable" }
say "accessed: " ~ $fh.accessed;
say "modified: " ~ $fh.modified;
say "changed: " ~ $fh.changed;
''.say;


### Caller
### 
sub foobar {
    say callframe().annotations;
}
foobar();
''.say;


### Chomp
###
my $line = "foobar\n";
my $new = $line.chomp;
say "-$line- -$new-";
''.say;


### Each
###
my %hash = ( jon => 'barton' );
for %hash.kv -> $k, $v { "-$k- -$v-".say }
''.say;


### FILE, LINE
###
say "I'm in $?FILE, on line $?LINE.";
say "I'm now in package " ~ $?PACKAGE.perl;
package Jontest {
    say "I'm now in package " ~ $?PACKAGE.perl;
}
''.say;


### fork
###
#use NativeCall; 
#sub fork returns int32 is native { * };
### Commenting this out because it results in a fork, and all the rest of the 
### output from here down gets duplicated.
#say "--" ~ fork() ~ "--";
#''.say;


### gmtime, localtime
###
my $gmtime = DateTime.now.utc;
say $gmtime;
my $lt = DateTime.now;
say "Day of week: " ~ $lt.day-of-week;
say "Current local hour: " ~ $lt.hour;
say "Current month: " ~ $lt.month;  # Jan == 1, Dec == 12
say $lt;
''.say;


### hex, oct
###
say :16('a');       # 10
say :8('100');      # 64
''.say;


### int
###
my $num = 3.9;
say $num.Int;
say $num.truncate;
say truncate $num;
say 3.9.truncate;       # surprisingly, this does work.
#say Int $num;          # Nope, can't do this.
say $num;
''.say;


### length
###
say "foobar".chars;
''.say;


### no
###
no strict;
$blargle = "flurble";   # no "my" declarator.
$blargle.say;
use strict;
''.say;


### opendir
###
my $dir = "/home/jon/Desktop".IO;
say $dir;
''.say;


### push
###
my @a = <a b c>;
my @b = <d e f>;
@b.push(@a);
say @b;             # [d e f [a b c]]
''.say;


### rand
###
my $r1 = rand;
say $r1;            # float between 0 and 1
say (^3).pick;
''.say;


### ref
###
my $aref = [1, 2, 9];
say $aref.WHAT.perl;
''.say;


### reverse
###
my @forward = <a b c>;
say reverse @forward;
'def'.flip.say;
''.say;


### sort
###
say <b c a>.sort;
say <b c a>.sort.join;
say <1 11 2 22 3 33>.sort;
say <1 22 10 39 7>.sort({ $^z <=> $^q });
''.say;


### split
###
my @split_arr_one = split '', 'abc';
say @split_arr_one.perl;
my $str = 'd,e,f';
my @split_arr_two = split(',', $str, :all);
say @split_arr_two.perl;
my @split_arr_three = 'abc'.comb;
say @split_arr_three.perl;
''.say;


### ucfirst, lcfirst
###
"now is the time for all good men".tc.say;
''.say;


### warn
###
note "This is a note.";
warn "this is a warning";
die "this is a fatal";





























