#!/usr/bin/env perl

use v5.10;



my $max = 1000;
make_modules($max);


sub make_modules {#{{{
    my $max = shift;

    open my $g, '>', "lib/Loader.pm6" or die $!;
    for (1..$max) {
        my $class_name = "test_$_";
        say {$g} "use Loader::$class_name;";


        open my $c, '>', "lib/Loader/${class_name}.pm6" or die $!;
        say {$c} "use SomeRole;";
        say {$c} "class Loader::$class_name does SomeRole {}";
        close $c;
    }
    close $g;

}#}}}

