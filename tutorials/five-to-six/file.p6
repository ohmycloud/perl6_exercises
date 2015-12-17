#!/home/jon/.rakudobrew/bin/perl6

### Open file for read-only
###
my $ro_fh = open "input_file.txt", :r;
$ro_fh.close;


### Open file for read/write
###
my $rw_fh = open "input_file.txt", :rw;
$rw_fh.close;


### You can probably guess how to open the file for write only.  I'm not doing 
### that here because I don't want to clobber my input_file.txt, which I'm 
### using in several of these sample scripts.


### Read lines into an array
### 
### It's now this simple.
my @lines = "input_file.txt".IO.lines;
@lines.say;

### In p6 you'd check for existence of the file first, and you'll probably 
### want to do that most of the time in p6, but if you skipped that step, the 
### program would automatically throw an exception for you:
#my @more_lines = "nonexistent_file.txt".IO.lines;   # Failed to open...

