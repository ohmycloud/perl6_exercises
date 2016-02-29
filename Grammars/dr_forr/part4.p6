#!/home/jon/.rakudo/install/bin/perl6


### This is the string we're trying to parse out.
my $js_str = 'var a = 3; console.log( "Hey, did you know a = " + a + "?" );';

### And this is the perl6 string we're wanting to end up with.
my $p6_str_goal = Q:to/EOP6/;
my $a = 3;
say "Hey, did you know a = " ~ $a ~ "?";
EOP6


### Our rules as we built them up in part 3 {# {{{

    ### Note that we're not creating variables out of these.  Just rules and 
    ### tokens that can then be used in other rules.
    my rule Integer { \d+ };
    my token QuotedString { '"' <-["]>+ '"' }
    my rule Variable { \w+ };
    my rule Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };


    ### This is our end-result rule, and is going to be used to match a 
    ### string.  So we do need an actual variable container this time.
    my $js-matching = rule { <Assignment-Expression> ';' <Func-Call> ';' };


    ### Match.
    say so $js_str ~~ $js-matching;

###}# }}}


