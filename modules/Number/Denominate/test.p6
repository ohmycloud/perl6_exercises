#!/usr/bin/env perl6

### https://github.com/zoffixznet/perl6-Number-Denominate
###
### More info on this in ROOT/tutorials_blogs/zoffix/small_scripts/polymod.p6

use Number::Denominate;





### Number::Denominate (also by Zoffix) can take a number of pre-defined 
### "sets" and break down a larger number for you.

### The default set is "time"
my $seconds = 86_500;
say denominate $seconds;                                                # 1 day, 1 minute, and 40 seconds

### I'm not in love with the set name "info" - it's too general.  But anyway:
my $bytes = 50_123_456_789;
say denominate $bytes, :set<info>;                                      # 50 gigabytes, 123 megabytes, 456 kilobytes, and 789 bytes
say denominate $bytes, :set<info-1024>;                                 # 46 gibibytes, 697 mebibytes, 464 kibibytes, and 277 bytes

### But there are a number of others, that will probably cover what you need.
my $light_year = 9_460_730_472.5808;
say denominate $light_year, :set<length>;                               # 9460730 kilometers and 472 meters

my $inches = 65_000;
say denominate $inches, :set<length-imperial>;                          # 1 mile, 45 yards, 1 foot, and 8 inches

### List of available sets:
###     https://github.com/zoffixznet/perl6-Number-Denominate#set

### And you can make up your own units if needed
say denominate 449, :units( foo => 3, <bar bors> => 32, 'ber');         # 4 foos, 2 bors, and 1 ber


### Looky.  denominate() even uses the Oxford comma.


