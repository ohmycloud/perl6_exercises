#!/home/jon/.rakudo/install/bin/perl6


my $rule = rule { \w+ \d+ };
my $str  = 'foo 3 bar';


if False {  # The problem {{{

    ### This just prints "True".
    my $r1 = $str ~~ $rule;
    say $r1;


    ### This prints out the match:  ｢foo 3 ｣
    my $r2 = $str ~~ rule { \w+ \d+ };
    say $r2.WHAT;

    ''.say;
}# }}}
if True {   # The solution {{{

    ### This form is returning a Bool, and putting the Match variable into $/
    my $r1 = $str ~~ $rule;
    say $r1;                    # here's the Bool we saw in the first block
    say $/;                     # and here's our match variable

    ### This form is directly returning the Match variable
    my $r2 = $str ~~ rule { \w+ \d+ };
    say $r2.WHAT;

    ###
    ### I don't know why the difference between the two forms.
    ###

    ''.say;
}# }}}


if False {  # Not really a problem, just a note. # {{{
    
    ### FWIW, this shows the difference between a rule and a token:
    say $str ~~ rule { \d+ };       # ｢3 ｣
    say $str ~~ token { \d+ };      # ｢3｣    (no trailing space)

}# }}}


