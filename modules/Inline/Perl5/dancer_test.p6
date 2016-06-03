#!/usr/bin/env perl6

use Inline::Perl5;

### Works fine.  Run this and then hit
###     http://localhost:3000/

if False {# {{{
    ### Perfectly cromulent.  Works.

    my $p5 = Inline::Perl5.new;

    $p5.run( q:to<PERL5> );
        use Dancer2;
        get '/' => sub {
            return "<a href='/jon'>Try hitting this</a>";
        };
        get '/:name' => sub {
            return "Why, hello there " . param('name');
        };
        dance;
    PERL5
        
}# }}}
if False {# {{{
    ### Same as the previous, except we're using the $p5.use() first.
    ### Works fine.

    my $p5 = Inline::Perl5.new;
    $p5.use('Dancer2');

    $p5.run( q:to<PERL5> );
        get '/' => sub {
            return "<a href='/jon'>Try hitting this</a>";
        };
        get '/:name' => sub {
            return "Why, hello there " . param('name');
        };
        dance;
    PERL5

}# }}}

