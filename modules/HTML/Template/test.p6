#!/home/jon/.rakudobrew/bin/perl6

use HTML::Template;

my $tmpl = IO::Path.new('Template.tmpl');

my %params = (
    title => "Hello, World!",
    authors => Array.new(
        { name => 'Joe' },
        { name => 'Steve' },
        { name => 'Fred' },
        { name => 'Barney' },
    );
);

my $ht = HTML::Template.from_file($tmpl);
$ht.with_params(%params);
say $ht.output;

