#!/usr/bin/env perl6

### Convert a whole bunch of a small unit (eg seconds) into its constituent 
### larger units (eg days, hours, minutes, remaining seconds).
###
###
### This file is for essentially copy/paste solutions.
###
### Explanation of wtf is going on in 
### ../tutorials_blogs/zoffix/small_scripts/polymod.p6

if False {  # bytes to any other format (gigabytes, terabytes, whatever)# {{{

    ### If you really have to start at bits instead of bytes, see that 
    ### polymod.p6 script which has an example of that.

    my $bytes = 50_234_567_890;

    my @sales_res = $bytes.polymod: 10³ xx ∞;
    my @real_res  = $bytes.polymod: 2**10 xx ∞;

    my @sales_units    = <bytes kB MB GB>;
    my @real_units     = <bytes KiB MiB GiB>;
    
    printf "%17s %d bytes is %s.\n", "Sales thinks",      $bytes, (@sales_res Z~ @sales_units).join(', ');
    printf "%17s %d bytes is %s.\n", "Programmers think", $bytes, (@real_res Z~ @real_units).join(', ');
}# }}}
if False {  # seconds to days, hours, minutes# {{{

    my $seconds = 97445;
    my ($sec, $min, $hour, $day) = $seconds.polymod: 60, 60, 24;
    say "sec: $sec";    # 5
    say "min: $min";    # 4
    say "hour: $hour";  # 3
    say "day: $day";    # 1

}# }}}

