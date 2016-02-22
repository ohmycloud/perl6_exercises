#!/home/jon/.rakudobrew/bin/perl6

### Measuring and improving run-time or compile-time performance
###     http://doc.perl6.org/language/performance



### Profile using the MoarVM backend:
###     $ perl6 --profile scriptname.p6
###     <output of scriptname.p6 appears here>
###     Writing profile output to profile-NUMBERS.NUMBERS.html
###
### Now just open that profile*.html in your browser.  The output is quite 
### nice-looking.
###


### Profile compiling process:
###     $ perl6 --profile-compile scriptname.p6
###     <output of scriptname.p6 appears here>
###     Writing profile output to profile-NUMBERS.NUMBERS.html
###
### Produces another profile*.html.  However, this produced file, even on a 
### simple script, is very large and includes some javascript that's locking 
### up my browser.



### Benchmarks
### perl6-bench is here:
###     https://github.com/japhb/perl6-bench
###
### It's not installable via panda, and I haven't played with it, but it's 
### worth a look I guess.


