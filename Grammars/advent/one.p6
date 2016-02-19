#!/home/jon/.rakudobrew/bin/perl6

my $str = q:to/EOT/;
    pickmany: Which items are food?
        ac: Rice
        ac: Orange
        ac: Mushroom
        ai: Shoes
    pickone: Which item is a color?
        ac: Orange
        ai: Shoes
        ai: Mushroom
        ai: Rice
    EOT


grammar Question::Grammar {
    token TOP {
        \n*
        <question>+
    }
    token question {
        <header> <answer>+
    }
    token header {
        ^^ $<type>=['pickone'|'pickmany'] ':' \s+ $<text>=[\N*] \n
    }
    token answer {
        ^^ \s+ $<correct>=['ac'|'ai'] ':' \s+ $<text>=[\N*] \n
    }
}

my $m = Question::Grammar.parse($str);
say $m.so;
''.say;


for $m<question> -> $q {
    say $q<header><text>;
    #say $q{'header'}{'text'};      # <> is the same as {''}, so this line is the same as the above.
}
''.say;


    ### The tut says that our for loop needs to look like this:
    ###     for $m<question>.flat -> $q {
    ###                     ^^^^^
    ###
    ### However, this tut was written in 2009, and that ".flat" is not needed 
    ### in 2016.
    ###
    ### That ".flat" shows up in several other spots later in the tut as well.  
    ### Just ignore all of them.





