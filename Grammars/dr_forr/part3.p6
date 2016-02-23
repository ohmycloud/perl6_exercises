#!/home/jon/.rakudo/install/bin/perl6


### This is the string we're trying to parse out.
my $str = 'var a = 3; console.log( "Hey, did you know a = " + a + "?" );';


if False {# {{{
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
if True {

    ### The block above just illustrates why we're using rules rather than 
    ### regexen, so the rule it uses is small for eg purposes.
    ###
    ### The rule we're actually going to be using is:

    my $rule = rule {
        var a '=' 3 ';'
        console '.' log '(' '"Hey, did you know a = "' '+' a '+' '"?"' ')' ';'  
    };
    
}

