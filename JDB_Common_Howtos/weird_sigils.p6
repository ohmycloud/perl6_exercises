#!/home/jon/.rakudobrew/bin/perl6


### 
### ~$
### 
### I don't know the name of this, but it's returning the matched string from 
### a match variable.
###
my $str = 'foobar';
my $m = $str ~~ /oob/;
say $m;                     # ｢oob｣
say ~$m;                    # oob   (no braces)



