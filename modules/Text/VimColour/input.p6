#!/usr/bin/env perl6

use v6;
use Text::VimColour;        # silly Brits.  Too many "u"s but not enough gunz!


#`{
    Uses vim to produce HTML that's syntax-colored as the installed vim would 
    do it.

    You have to have vim >= 7.4 installed on the system, and you have to have 
    the appropriate syntax files installed.


    This is sometimes a little ugly when being run (see the perl5 bit), but it 
    does work to produce nicely-colored HTML pages.




    Don't try to use this script as the input file.  Somebody (probably vim) 
    is having trouble opening this file while it's running as a script.  So 
    make a copy of this and use that copy as input.
}


if False {  # input is hard-coded here - no good# {{{
    ### Doesn't do diddly shit.
    ### But honestly, you'd never use it this way anyhow.
    Text::VimColour.new(
        lang => "perl6",
        code => "print 'y helo thar';",
        out  => 'this_file_never_gets_produced.html',
    );
}# }}}

if True {  # perl5 input - partially good# {{{

    ### Appears to blows up, but actually works.
    ###
    ### This produces a multiline error telling you that it failed to run the 
    ### requested vim command because "exit code 1".
    ###
    ### HOWEVER, "perl.html" does get produced, and it's (mostly, at least) 
    ### correct HTML version of vim's syntax coloring of the perl5 "input.pl".
    Text::VimColour.new(
        lang => "perl",
        in => "input.pl",
        out  => 'perl.html',
    );
}# }}}
if False {  # perl6 input - works fine.# {{{

    ### Specify the outfile here in the code
    Text::VimColour.new(
        lang => "perl6",
        in => "input.p6",       # a copy of this file.
        out  => 'perl6.html',
    );

    ### Or get the HTML returned to us as a string and produce the outfile 
    ### ourselves.
    my $out = Text::VimColour.new(
        lang => "perl6",
        in => "input.p6",
    ).html-full-page;
    'perl6_2.html'.IO.spurt($out);
}# }}}

