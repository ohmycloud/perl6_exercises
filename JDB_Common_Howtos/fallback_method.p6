#!/usr/bin/env perl6


if False {# {{{


#|{
    The FALLBACK method gets called when an undeclared method name is called, 
    provided the args match.
    
    The first arg to FALLBACK is the method name actually called.
#}
class Jontest {
    multi method FALLBACK (Str $meth_name, Str $arg) {
        say "FALLBACK was called via method '$meth_name'.";
        say "FALLBACK got string $arg.";
    }
    multi method FALLBACK (Str $meth_name, Int $num) {
        say "FALLBACK was called via method '$meth_name'.";
        say "int FALLBACK got number $num.";
    }
}

my $j = Jontest.new;

$j.wants_string('foo');
''.say;

$j.wants_num(34);

}# }}}
if True {

    =for comment
        The example given in jnthan's slide
            http://jnthn.net/papers/2015-fosdem-static-dynamic.pdf
        involves an HTML class that doesn't need to specify every @$% tag.


    ###  Holy shit.

    class HTML {
        method FALLBACK($tag, :%attrs, *@kids) {
            my $attr_str = %attrs.fmt( " %s='%s'", "" );
            my $kids_str = @kids.join('');
            "\<$tag$attr_str\>$kids_str\</$tag\>";
        }
    }

    my $h = HTML.new;

    my $bold = $h.b("This is bold.");
    say $bold;                          # <b>This is bold.</b>
    ''.say;

    my $it = $h.i( "This is italicized and heavy.", :attrs({:font_weight('heavy')}) );
    say $it;                            # <i font_weight='heavy'>This is italicized and heavy.</i>
    ''.say;

    my $para = $h.p( $bold, $it, "This is some paragraph text" );
    say $para;                          # <p><b>This is bold.</b><i font_weight='heavy'>This is italicized and heavy.</i>This is some paragraph text</p>
    ''.say;





}













