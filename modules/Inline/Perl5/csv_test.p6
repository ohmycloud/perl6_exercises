#!/usr/bin/env perl6

use Inline::Perl5;

if True {

    my $p5 = Inline::Perl5.new;
    $p5.use('Text::CSV');

    ### my $csv = Text::CSV->new
    my $csv = $p5.invoke('Text::CSV', 'new');

    ### $csv->combine( qw(one two three) );
    $csv.combine( <one two three> );

    ### say $csv->string;
    $csv.string.say;

}

