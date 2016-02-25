#!/home/jon/.rakudo/install/bin/perl6


### This is the string we're trying to parse out.
my $str = 'var a = 3; console.log( "Hey, did you know a = " + a + "?" );';



#`(
    In the three blocks below, we're building up a rule to match our 
    JavaScript string.

    Set the conditionals on the blocks to True one at a time, and follow 
    through the code as you run it.
#)
    



if False {  ### Matching the assignment # {{{
    ### The first point he makes is that "var a = 3;" can be hard to parse, 
    ### because different programmers will space it out differently.
    ###     var a=3;
    ###     var a = 3;
    ###     var a       = 3;
    ### etc


    ### So this works:
    say so $str ~~ / \s* var \s* 'a' \s* '=' \s* 3 \s* ';' \s* /;   # True
        ### But it's horrifying to look at.

    ### Instead of a regex, use a rule
    say so $str ~~ rule { a '=' 3 ';' }
        ### That's much less horrifying to look at, and it handles any spacing 
        ### around the assignment that the user might have used.  
        ### 
        ### But it's a rule, and its doing that weird :sigspace thing that 
        ### rules do, so it's a little hard for me to predict that it matches.  
        ### I mean, it does, but I'm not just "seeing" <.ws> yet.
        ###
        ### See ../Grammars/README for more info (Token and Rule Declarators).
    
}# }}}
if False {  ### Matching the console.log() # {{{

    ### We're now matching the assignment bit OK.  Time to work on matching 
    ### the "console.log(...)" bit.
    ###
    ### A character class in p6 looks like:
    ###         <[abc]>
    ###     Spacing doesn't matter, so this would be the same:
    ###         <[ a b c ]>
    ###     If we wanted to be super explicit, we'd specify that we're 
    ###     enabling the character class by adding a + after the opening 
    ###     angle:
    ###         <+[abc]>
    ###
    ### The default sign on a character class is '+' so we'll usually omit it.  
    ### But to negate a character class, the sign is required, and now it's a 
    ### '-':
    ###         <-[a b c]>
    ###
    ###
    ### SO, all that being said, to match the string being passed to 
    ### console.log(), we want to match
    ###         - An opening quote
    ###         - Any number of anything but a quote
    ###         - A closing quote
    ###         - The string '+'
    ###         - The letter 'a' (our variable name)
    ###         - The string '+'
    ###         - An opening quote
    ###         - Any number of anything but a quote (the ending punctuation)
    ###         - A closing quote
    ###         - The ending paren and terminating semicolon
    ###     This is still awfully specific, but you get the idea, I guess.
    ###
    ###
    ### At this point, the code in the blog fails to match the negated 
    ### character classes multiple times.  He uses
    ###         <-["]>
    ###     where he should be using
    ###         <-["]>+
    ###     so I fixed that.
    ###
    ###
    ### At this point, we should be able to match pretty much any two 
    ### hardcoded strings joined with our variable in the middle:
    ###     ("Looky, our var is" + a + "!  Neato!");
    ###     ("foo" + a + "bar");
    ### etc.


    my $rule = rule {
        var a '=' 3 ';'
        console '.' log '(' '"' <-["]>+ '"' '+' a '+' '"' <-["]>+ '"' ');'
    };

    say so $str ~~ $rule;
    
}# }}}
if True {  ### Polishing that console.log() match # {{{

    ###
    ### The match in the previous section works, but it's hideous.
    ###

    ### The first bit of hideousness is having to include the "quote followed 
    ### by anything but a quote followed by a quote" character class multiple 
    ### times.  Let's get rid of that:
    my token QuotedString { '"' <-["]>+ '"' }
    

    ### Here's the rule we came up with in the previous section:
    my $previous_rule = rule {
        var a '=' 3 ';'
        console '.' log '(' '"' <-["]>+ '"' '+' a '+' '"' <-["]>+ '"' ');'
    };


    ### And here's the same rule, but embedding our <String> rule makes it 
    ### much nicer to look at:
    my $new_rule_a = rule {
        var a '=' 3 ';'
        console '.' log '(' <QuotedString> '+' a '+' <QuotedString> ');'
    };
    say so $str ~~ $new_rule_a;


    ### While we're at it, we're currently matching only variables named "a", 
    ### so let's fix that with another rule, and then update our main rule:
    my rule Variable { \w+ };

    ### This contains a few more characters, but will match any variable name, 
    ### and is easier to look at:
    my $new_rule_b = rule {
        var <Variable> '=' 3 ';'
        console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ');'
    };
    say so $str ~~ $new_rule_b;



    ### We're only matching when the variable is being assigned to a value of 
    ### exactly '3'.  Update just like we did with Variable:
    my rule Integer { \d+ };
    my $new_rule_c = rule {
        var <Variable> '=' <Integer> ';'
        console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ');'
    };
    say so $str ~~ $new_rule_c;



    ### Moar Abstraction!
    my rule Integer-Assignment-Expression { var <Variable> '=' <Integer> };
    my rule Console-Log-Call { console '.' log '(' <QuotedString> '+' <Variable> '+' <QuotedString> ')' };
    my $new_rule_d = rule {
        <Integer-Assignment-Expression> ';' 
        <Console-Log-Call> ';'
    };
    say so $str ~~ $new_rule_d;
    
}# }}}

