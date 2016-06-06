#!/usr/bin/env perl6

### http://perl6.party/post/Perl6-.polymod-break-up-a-number-into-denominations
###


if False {   # quickie example# {{{
    my $num = 121;
    say $num.polymod: 60;   # (1 2)
    ''.say;

    ### I don't know what that colon is doing there, or what that structure is 
    ### called.
    ### 
    ### So far this seems pretty uninteresting.  But we can pass more than one 
    ### argument to polymod.
    ###

}# }}}
if False {   # slightly more extended quickie example# {{{
    my $seconds = 3603;
    say $seconds.polymod: 60, 60;       # (3 0 1)

    ### So that's:
    ###     3 - seconds
    ###     0 - minutes
    ###     1 - hours

    ### So, to make things a little clearer:
    my ($sec, $min, $hr) = $seconds.polymod: 60, 60;
    say "-$sec- -$min- -$hr-";
    ''.say;
}# }}}
if False {   # Same idea, more explanation# {{{
    my $seconds = 1 * 60*60*24 # days
                + 3 * 60*60    # hours
                + 4 * 60       # minutes
                + 5;           # seconds

    say $seconds;                           # 97445

    say $seconds.polymod: 60, 60, 24;       # (5 4 3 1)

    ### This is easier to look at:
    my ($sec, $min, $hour, $day) = $seconds.polymod: 60, 60, 24;
    say "sec: $sec";    # 5
    say "min: $min";    # 4
    say "hour: $hour";  # 3
    say "day: $day";    # 1

=begin walkthrough


I'm using an imaginary Seq variable named $seq below.  This is to illustrate 
what's happening -- the $seq variable is not a documented part of polymod.

I'm calling it a Seq because polymod returns a Seq.  But I'm using "unshift", 
again to illustrate what's happening.  You can't actually unshift a Seq.

Just understand that anything below touching $seq is for illustration of 
concept.


STEP 1 - int($seconds / (60 * 60 * 24)) 
    - int(97445 / 86400) is 1
        - unshift that result into $seq
        - $seq = (1)
    - The remainder is 11045, which gets passed to step 2.

STEP 2 - int(11045 / (60 * 60))
    - int(11045 / 3600) is 3
        - unshift that result into $seq
        - $seq = (3, 1)
    - Remainder is 245, pass it on to step 3.

STEP 3 - int(245 / 60)
    - int(245 / 60) is 4
        - unshift that result into $seq
        - $seq = (4, 3, 1)
    - Remainder is 5.
        - Since there are no more args to pass this remainder on to, it 
          becomes our last result.
        - unshift that result into $seq
        - $seq = (5, 4, 3, 1)

return $seq;

=end walkthrough

    ''.say;
}# }}}
if True {   # Similar idea, now with data storage sizes.# {{{

    {# {{{
        my $bits = 50_234_567_890;

        ### Pick one.
        #my ($bi, $by, $kb, $mb, $gb) = $bits.polymod: 8, 1000, 1000, 1000;
        my ($bi, $by, $kb, $mb, $gb) = $bits.polymod: 8, 10³, 10³, 10³;

        say "gb: $gb";
        say "mb: $mb";
        say "kb: $kb";
        say "by: $by";
        say "bits: $bi";
        ''.say;

        ### Remember that we started out with 50 billion _bits_, not bytes.  
        ### That's why the numbers produced aren't adding up in your head 
        ### correctly.
    }# }}}
    {# {{{
        ### Since we generally deal with (and think in) bytes more than bits, 
        ### let's just start out with our smallest unit being bytes.
        my $bytes = 50_234_567_890;


        ### So this time, our first arg to polymod is not 8 anymore, since 
        ### we're starting out with bytes.
        my @res1 = $bytes.polymod: 10³, 10³, 10³;


        ### So now we've got three identical arguments.  What if we had a 
        ### bigger number of bits and wanted to extend out to terabytes or 
        ### beyond?  We'd have to add another 10³ arg, and another to extend 
        ### to petabytes, etc.
        ###
        ### Since all of our args are identical, we can get lazy about this:
        my @res2 = $bytes.polymod: 10³ xx ∞;
        say @res2;                                      # [890 567 234 50]


        ### OK, but how about we label those numbers.  Here's an array of unit 
        ### labels:
        my @marketing_units = <bytes kB MB GB>;

        ### Now we can Zip our @res and @marketing_units arrays together:
        my @list_res = @res2 Z @marketing_units;
        say @list_res;                                  # [(890 bits) (567 bytes) (234 kB) (50 MB)]

        ### Better, but that's an array of lists.  The Zip operator applies 
        ### the operator given to it to each element in the two arrays, 
        ### sequentially.
        ### We didn't give it an operator above, so it just returned lists.
        ###
        ### This time, let's give it a string concatenation operator:
        my @human_res = @list_res Z~ @marketing_units;
        say @human_res;                                 # [890bytes 567kB 234MB 50GB]
        ''.say;

        ### Getting there - @human_res is now an array of strings.



        {
            ### But a proper megabyte is not 1000 kilobytes.  It's 1024 
            ### kilobytes.  You know that and I know that, but the muggles in 
            ### sales aren't having any of it.
            ###
            ### Make everybody happy.
            my $bytes = 50_234_567_890;
            my @sales_res = $bytes.polymod: 10³ xx ∞;
            my @real_res  = $bytes.polymod: 2**10 xx ∞;

            my @sales_units    = <bytes kB MB GB>;
            my @real_units     = <bytes KiB MiB GiB>;

            printf "%17s %d bytes is %s.\n", "Sales thinks",      $bytes, (@sales_res Z~ @sales_units).join(', ');
            printf "%17s %d bytes is %s.\n", "Programmers think", $bytes, (@real_res Z~ @real_units).join(', ');
            ''.say;

            #      Sales thinks 50234567890 bytes is 890bytes, 567kB, 234MB, 50GB.
            # Programmers think 50234567890 bytes is 210bytes, 427KiB, 803MiB, 46GiB.



            ### We're so close now.  But the way the values and labels zipped 
            ### together isn't quite making anybody happy.
            ###
            ### Number::Denominate (also by Zoffix) can take a number of 
            ### pre-defined "sets", two of which are "info" and "info-1024" 
            ### that do exactly what we want.
            use Number::Denominate;
            say denominate $bytes, :set<info>;              # 50 gigabytes, 234 megabytes, 567 kilobytes, and 890 bytes
            say denominate $bytes, :set<info-1024>;         # 46 gibibytes, 803 mebibytes, 427 kibibytes, and 210 bytes

            ### The 'time' set is the default, and there are others:
            my $seconds = 86_500;
            say denominate $seconds;                        # 1 day, 1 minute, and 40 seconds
            
            my $light_year = 9_460_730_472.5808;
            say denominate $light_year, :set<length>;       # 9460730 kilometers and 472 meters

            ### And you can make up your own units if needed
            say denominate 449, :units(                     # 4 foos, 2 bors, and 1 ber
                                    foo => 3,
                                    <bar bors> => 32,
                                    'ber'
                                );
        }

    }# }}}

}# }}}


