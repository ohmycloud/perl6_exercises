#!/home/jon/.rakudobrew/bin/perl6

### This does not appear in this "Syntax" section of the tutorial, but it 
### seems like a reasonable place for it, and I want this to show up when I 
### grep for it.
###     HEREDOC
###     HERE Doc
###     here doc
###     heredoc


{ # Basics# {{{

    my $str = q:heredoc"END";
        foo
        bar
        baz
    END

    say "-$str-";


#`(

Output is what you'd expect:

-    foo
    bar
    baz
-

)


}# }}}
{ # Indentation# {{{

    ### This looks just like the version we used in Basics, above, except that 
    ### I've indented the END marker.
    my $str = q:heredoc"END";
        foo
        bar
        baz
        END

    say "-$str-";


#`(

The entire string takes indentation hints from the position of that ending 
marker, so our output now looks like what we actually intended:

-foo
bar
baz
-

)


}# }}}
{ # End marker delimiters# {{{

    ### Our END marker can be specified with "" as in the previous two 
    ### examples, or with pretty much any other delimiter.
    ###
    ### The following is NOT using a regex as the END marker, it's just using 
    ### slashes as the delimiter.

    my $str = q:heredoc/END/;
        foo
        bar
        baz
        END

}# }}}
{ # Adverb shortcut # {{{

    ### Up till now I've used the adverb ":heredoc", which is long to type.  
    ### We can shorten that to ":to":

    my $str = q:to/END/;
        foo
        bar
        baz
        END

}# }}}
{ # Interpolation# {{{

    ### The construct
    ###     q:to/END/;
    ### uses the no-interpolating q// quoting construct, so:    

    my $fname = 'jon';
    my $lname = 'barton';

    my $str1 = q:to/END/;
        foo
        bar
        $fname
        $lname
        baz
        END
    say $str1;
    ''.say;
#`(
    Output:
    foo
    bar
    $fname
    $lname
    baz
)


    ### We can enable the :c adverb, which only allows interpolation of 
    ### closures:
    my $str2 = q:to:c/END/;
        foo
        bar
        {$fname}
        $lname
        baz
        END
    say $str2;
    ''.say;
#`(
    Output:
    foo
    bar
    jon
    $lname
    baz
)


    ### But really, if we want interpolation, we usually want the whole thing, 
    ### in which case we can omit the :c adverb and use qq// instead of q//
    my $str3 = qq:to/END/;
        foo
        bar
        $fname
        $lname
        baz
        END
    say $str3;
    ''.say;
#`(
    Output:
    foo
    bar
    jon
    barton
    baz
)



}# }}}
{ # Combining# {{{


    ### This strikes me as a little bit far-fetched.
    ###
    ### On top of being far-fetched, it's buggy.  I'd suggest avoiding this.
    ###
    ### But we can chain multiple end markers that use different quoting 
    ### constructs.

my Str $name    = 'Jon';
my Str $signoff = 'Your favorite online store';

say qq:to/TOP/, q:to:c/PRICE/, qq:to/END/;
    Dear $name,

    Thanks for your recent purchase.  Your total purchase price comes to
    TOP
        $33.40
    PRICE

    Thanks for your patronage!
    $signoff
    END


#`(

That chaining seems to still be a little buggy.  I tried variablizing the 
price and including that as a closure:

my Rat $price = 33.40;
say qq:to/TOP/, q:to:c/PRICE/, qq:to/END/;
    Dear $name,

    Thanks for your recent purchase.  Your total purchase price comes to
    TOP
        ${$price}
    PRICE

    Thanks for your patronage!
    $signoff
    END

....however, that just blew up, unable to find the PRICE ending delimiter.

)





}# }}}


{ # TL;DR# {{{


    ### with interpolation - qq//
        my $name = 'Jon';
        say qq:to/END/;
            Hello $name.
            It's nice to see you!
            END


    ### without interpolation - q//
        say q:to/END/;
            Hello there.
            The thing you purchased cost $32.98.
            END



}# }}}


