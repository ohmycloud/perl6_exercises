#!/home/jon/.rakudo/install/bin/perl6


### This is the JavaScript string we're going to parse.
my $js_str = 'var a = 3; console.log( "Hey, did you know a = " + a + "?" );';

### And this is the perl6 string we're wanting to end up with.
my $p6_str_goal = Q|my $a = 3; say "Hey, did you know a = " ~ $a ~ "?";|;


if False {# {{{ ### Our rules as we built them up in part 3

    ### We're not creating variables out of these.  Just rules and tokens that 
    ### can then be used by name in other rules.
    my token QuotedString { '"' <-["]>+ '"' }
    my rule Integer { \d+ };
    my token Variable { \w+ };
    my rule Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };


    ### The tut lists Variable as a rule, not a token.  But when spitting out 
    ### the whole match (end of this block):
    ###     Variable as rule:       ｢a ｣
    ###     Variable as token:      ｢a｣
    ###
    ### The space is not part of a variable name, but the way a rule deals 
    ### with whitespace includes it.
    ###
    ### I'm going to keep it as a token for now, but if shit starts to blow up 
    ### in a way not indicated by the tut later on, change it back to a rule.



    ### This is our end-result rule, and is going to be used to match a 
    ### string.  So we do need an actual variable container this time.
    my $js-matching = rule { <Assignment-Expression> ';' <Func-Call> ';' };


    ### Match.
    say $js_str ~~ $js-matching;
    say $/;


    ''.say;

}# }}}
if False {# {{{ ### A note on pseudo-casting

    my token QuotedString { '"' <-["]>+ '"' }
    my rule Integer { \d+ };
    my token Variable { \w+ };
    my rule Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
    my $js-matching = rule { <Assignment-Expression> ';' <Func-Call> ';' };

    ### Do the match
    $js_str ~~ $js-matching;

    ### Dig a specific bit out of the match variable
    say $/<Assignment-Expression><Integer>;             # ｢3｣

    ### OK, almost.  We don't want those Japanese quotes in there, so "cast" 
    ### that into a number by preceding it with a sign:
    say +$/<Assignment-Expression><Integer>;            # 3

    ''.say;

    ### The match object $/ has implicit string, number, and boolean values 
    ### inside it that get used depending on context.
    ###
    ### Remember that the word "Integer" as used in the code below is just 
    ### what I named my rule.  It could be called "Charlie" --- it is not part 
    ### of the casting point I'm trying to make here.
    say $/<Assignment-Expression><Integer> + 2;             # 5
    say "Here: $/<Assignment-Expression><Integer>";         # Here: 3
    say "Bool! " if $/<Assignment-Expression><Integer>;     # Bool!

}# }}}
if False {# {{{ ### Start to turn the JS into Perl

    my token QuotedString { '"' <-["]>+ '"' }
    my rule Integer { \d+ };
    my token Variable { \w+ };
    my rule Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
    my $js-matching = rule { <Assignment-Expression> ';' <Func-Call> ';' };

    ### Do the match
    $js_str ~~ $js-matching;


    ### Start to generate Perl code
    say 'my $'
        ~ $/<Assignment-Expression><Variable>
        ~ ' = '
        ~ $/<Assignment-Expression><Integer>
        ~ ';'
    ;
    ### Outputs:
    ###     my $a = 3;


    ### So far, so good.
    ###
    ### But we're going to want to get at the QuotedString from the JS, and 
    ### there are two of those, so we can't just access
    ###     $/<Func-Call><QuotedString>
    ### 
    ###     Commented to reduce output noise, but works.
    ###
    ### So, obviously, we're going to subscript that:
    #say $/<Func-Call><QuotedString>[0];                 # ｢"Hey, did you know a = "｣
    #say $/<Func-Call><QuotedString>[1];                 # ｢"?"｣
    #''.say;
    

    ### To see how we knew how to do that:
    ###     Commented to reduce output noise, but it works.
    #say $/<Func-Call>;
        ### Outputs:
            ### ｢console.log( "Hey, did you know a = " + a + "?" )｣
            ###     QuotedString => ｢"Hey, did you know a = "｣
            ###     Variable => ｢a｣
            ###     QuotedString => ｢"?"｣
    ### The indentation in the actual output isn't quite that severe, but it's 
    ### there.  And you can see that there are two QuotedString elements that 
    ### are both part of the Func-Call element.


    ### So, back to generating our Perl code.  
    ### 
    ### The Japanese braces in the comments are not part of the output this 
    ### time, I'm adding them just to specify exactly what each piece 
    ### contains.
    say 'say '
        ~ $/<Func-Call><QuotedString>[0]    # ｢"Hey, did you know a = "｣
        ~ ' ~ '                             # ｢ ~ ｣  
        ~ '$'                               # ｢$｣
        ~ $/<Func-Call><Variable>           # ｢a｣
        ~ ' ~ '                             # ｢ ~ ｣
        ~ $/<Func-Call><QuotedString>[1]    # ｢"?"｣
        ~ ';'                               # ｢;｣
    ;
    ''.say;
        ### Outputs:
        ###     say "Hey, did you know a = " ~ $a ~ "?";
        ###
        ### Sure, p6 could interpolate the $a right into the string, so what 
        ### we're outputting isn't exactly the way you'd write that, though 
        ### it's perfectly cromulent.
        ###
        ### But our literal strings already exist as two pieces, already 
        ### individually wrapped in quotes.  So it makes sense to just cat $a 
        ### in between the two.

}# }}}
if False {# {{{ ### Refactoring

    my token QuotedString { '"' <-["]>+ '"' }
    my rule Integer { \d+ };
    my token Variable { \w+ };
    my rule Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
    my $js-matching = rule { <Assignment-Expression> ';' <Func-Call> ';' };

    $js_str ~~ $js-matching;



    ### The code in the previous block works, but there's lots of repetition, 
    ### especially of the <Assignment-Expression> and <Func-Call> names, which 
    ### are long and noisy.
    ###
    ### Sub that shit!
    sub assignment_expression ($/) {
        'my $' ~ $/<Variable> ~ ' = ' ~ $/<Integer> ~ ';'
    }
    sub func_call ($/) {
        'say ' ~ $/<QuotedString>[0] ~ ' ~ $' ~ $/<Variable> ~ ' ~ ' ~ $/<QuotedString>[1] ~ ';';
    }
    say assignment_expression( $/<Assignment-Expression> );
    say func_call( $/<Func-Call> );
    ''.say;


    ### So much nicer, visually, than the code in the previous block.
    ###
    ### But still, we're catting all of the strings together.  Since we're 
    ### using tildes to cat the strings, and we're also outputting a lot of 
    ### tildes, the code above is looking like p6's version of leaning 
    ### toothpick syndrome.
    ###
    ### TMT == Too Many Tildes.
    ### 
    ### p6 is perfectly capable of interpolating variables, so let's use that.
    ###
    ### We still want to use non-interpolating quotes around the $ sigils that 
    ### we need to print (so we don't have to backwhack them), but everything 
    ### else can just be jammed together.
    sub assignment_expression2 ($/) {
        'my $' ~ "$/<Variable> = $/<Integer>;"
    }
    sub func_call2 ($/) {
        "say $/<QuotedString>[0]  ~ " ~ '$' ~ "$/<Variable> ~ $/<QuotedString>[1];";
    }
    say assignment_expression2( $/<Assignment-Expression> );
    say func_call2( $/<Func-Call> );
    ''.say;


    ### OK, better.  But that's still a lot of consecutive tildes with 
    ### different meanings, and that's a little hard to look at.
    ###
    ### Maybe backwhacking those $ sigils isn't all that bad after all?
    sub assignment_expression3 ($/) {
        "my \$$/<Variable> = $/<Integer>;"
    }
    sub func_call3 ($/) {
        "say $/<QuotedString>[0]  ~ \$$/<Variable> ~ $/<QuotedString>[1];";
    }
    say assignment_expression3( $/<Assignment-Expression> );
    say func_call3( $/<Func-Call> );


    ### Getting more readable.  But now, the backwhacks in front of our $ 
    ### sigils are visually clashing with the forwhacks in the variable $/.
    ### 
    ### But remember that $/ is special.  When used in subs like that, we can 
    ### actually drop the slash inside the sub.  $/<Variable> and just 
    ### $<Variable> are the same thing as long as our signature takes in $/.
    sub assignment_expression4 ($/) {
        "my \$$<Variable> = $<Integer>;"
    }
    sub func_call4 ($/) {
        "say $<QuotedString>[0]  ~ \$$<Variable> ~ $<QuotedString>[1];";
    }
    say assignment_expression4( $<Assignment-Expression> );
    say func_call4( $<Func-Call> );

    ### Now, the backwhacks on the $ sigils we mean to output no longer 
    ### visually conflicts with the forwhacks in $/ and the whole mess is 
    ### pretty readable.

}# }}}
if False {# {{{ ### Objectification

    my token QuotedString { '"' <-["]>+ '"' }
    my rule Integer { \d+ };
    my token Variable { \w+ };
    my rule Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
    my $js-matching = rule { <Assignment-Expression> ';' <Func-Call> ';' };


    sub assignment_expression ($/) {
        "my \$$<Variable> = $<Integer>;"
    }
    sub func_call ($/) {
        "say $<QuotedString>[0]  ~ \$$<Variable> ~ $<QuotedString>[1];";
    }


    ### Instead of making these two separate function calls:
    ###     say assignment_expression( $<Assignment-Expression> );
    ###     say func_call( $<Func-Call> );
    ###
    ### ...we'll put those calls into their own sub and call that.  This sub 
    ### is our "top-level rule", so we'll call it "top":
    sub top ($/) {
        ### TUT BUG
        ### The blog at this point just passes $/ as the argument to both of 
        ### these function calls - that isn't going to work.  We either have 
        ### to pass in the correct match here, or change both subs above to 
        ### access the correct pieces from $/.
        assignment_expression( $<Assignment-Expression> ) ~ func_call( $<Func-Call> );
    }

    $js_str ~~ $js-matching;
    say top($/);


}# }}}
if False {# {{{ ### Grammarfication

    ### Take all of our existing rules and wrap them up into a Grammar.
    grammar JavaScript {
        token   QuotedString { '"' <-["]>+ '"' }
        rule    Integer { \d+ };
        token   Variable { \w+ };
        rule    Assignment-Expression { var <Variable> '=' <Integer> };
        rule    Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
        rule    TOP { <Assignment-Expression> ';' <Func-Call> ';' };
    }

    ### Take all of our existing subs and wrap them up into an Actions class.
    ###
    ### In the previous blocks, I'd been using underscores and all lc() in the 
    ### subroutine names.
    ###
    ### But now that we're gathering everything up, we want the names of the 
    ### methods in the Actions class to exactly match the names of the rules 
    ### in the Grammar.
    class JSActions {
        method Assignment-Expression ($/) {
            "my \$$<Variable> = $<Integer>;"
        }
        method Func-Call ($/) {
            "say $<QuotedString>[0]  ~ \$$<Variable> ~ $<QuotedString>[1];";
        }
        method TOP ($/) {
            self.Assignment-Expression( $<Assignment-Expression> )
            ~ self.Func-Call( $<Func-Call> );
        }
    }


    ### This is perfectly legal.
    ### We parse out our string first using the grammar, and then pass the 
    ### match variable along to out Actions class.
    ###
    ### This works completely correctly as-is, but it's not where we want to 
    ### end up.
    if False {
        my $js      = JavaScript.new;
        $js.parse( $js_str );

        my $actions = JSActions.new;
        say $actions.TOP( $/ );
    }


    ### We can perform the same actions with less typing.
    my $js      = JavaScript.new;
    my $actions = JSActions.new;

    ### All of these say() lines are identical.  Pick the one you like.
    #say $js.parse( $js_str, :actions(JSActions.new) );
    #say $js.parse( $js_str, actions => JSActions.new );
    #say $js.parse( $js_str, :actions($actions) );
    #say $js.parse( $js_str, actions => $actions );

    ### HOWEVER, at this point, all of those say() lines are printing out the 
    ### details of our match in Japanese quotes rather than just printing out 
    ### our translated p6 line:
        ### ｢var a = 3; console.log( "Hey, did you know a = " + a + "?" );｣
        ###     Assignment-Expression => ｢var a = 3｣
        ###      Variable => ｢a｣
        ###      Integer => ｢3｣
        ###     Func-Call => ｢console.log( "Hey, did you know a = " + a + "?" )｣
        ###         QuotedString => ｢"Hey, did you know a = "｣
        ###         Variable => ｢a｣
        ###         QuotedString => ｢"?"｣


    ### We're going to fix this problem in the next block.

}# }}}
if True {# {{{ ### Final Grammarfication


    ### I'm renaming both the grammar and actions class so they don't conflict 
    ### with the code used in the previous block.


    grammar MyJavaScript {
        token   QuotedString { '"' <-["]>+ '"' }
        rule    Integer { \d+ };
        token   Variable { \w+ };
        rule    Assignment-Expression { var <Variable> '=' <Integer> };
        rule    Func-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
        rule    TOP { <Assignment-Expression> ';' <Func-Call> ';' };
    }

    ### In the previous block, our action methods were just returning their 
    ### strings, and p6 wasn't sure what to do with that.
    ###
    ### Instead of just returning a string, call "make" on the output.  This 
    ### modifies the Abstract Syntax Tree.
    class MyJSActions {
        method Assignment-Expression ($/) {
            make "my \$$<Variable> = $<Integer>;"
        }
        method Func-Call ($/) {
            make "say $<QuotedString>[0]  ~ \$$<Variable> ~ $<QuotedString>[1];";
        }

        ### In the previous version of TOP, we were calling self.METHOD.
        method TOP_OLD ($/) {
            self.Assignment-Expression( $<Assignment-Expression> )
                ~ self.Func-Call( $<Func-Call> );
        }

        ### But here, we're:
        ###     - Doing away with "self" altogether
        ###     - Catting together the previous rules' AST outputs
        ###     - Calling our own "make" to modify TOP's AST.
        method TOP ($/) {
            make $<Assignment-Expression>.ast ~ $<Func-Call>.ast;
        }
    }



    ### We're now printing the output of parse()'s .ast method.
    my $js = MyJavaScript.new;
    say $js.parse( $js_str, :actions(MyJSActions.new) ).ast;



    ### The tutorial still does not explicitly talk about what TOP is, it just 
    ### tells us to use it.
    ###
    ### I'm pretty sure that it's just the required name of the top-level rule 
    ### in a grammar, which gets run automatically.




    ### The blog does not cover this, but all of the ".ast" calls above can be 
    ### changed to ".made", and the code will work identically.
    ### 
    ### I've seen ".made" being used instead of ".ast" in another tutorial 
    ### somewhere, though it was never explained.
    ###
    ### I suspect that ".made" is just syntactical sugar that jibes better 
    ### with "make".

}# }}}


