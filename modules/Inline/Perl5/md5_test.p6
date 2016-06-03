#!/usr/bin/env perl6


### No need to "use Inline::Perl5" here.


### Import the MD5 module from Perl5.
use MD5:from<Perl5>;

### At this point, we can use the MD5 module using perl6 syntax.
my $m = MD5.new;
$m.add('foo');
$m.hexdigest.say;

=begin same_code_in_perl5
    use MD5;
    my $m = MD5->new();
    $m->add('foo');
    say $m->hexdigest;
=end same_code_in_perl5

