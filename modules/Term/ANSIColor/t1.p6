#!/usr/bin/env perl6

use v6;


#use Term::ANSIColor;
use Terminal::ANSIColor;


#`{
    AFAICT, the two modules listed are the same code by the same guy, but the 
    Terminal version is more recent.  It looks like the only difference 
    between the two versions is s/Term/Terminal/g and it looks like this is 
    because of some naming conflict.

    Whichever version you use, this produces the three lines of text below, 
    colored as expected.

    However, the Term version also produces a nasty warning that tells me that 
    color(), as used by the module, is deprecated.

    It then tells me to use Terminal::ANSIColor.



    TL;DR
        use Term::ANSIColor;                # NO NOPE DON'T USE THIS
        use Terminal::ANSIColor;            # And there was much rejoicing



}
say BOLD, "This is bold.", RESET;
say color('underline red on_yellow'), "This is underlined red on yellow", color('reset');
say colored("This is bold green on blue.", "bold green on_blue");

