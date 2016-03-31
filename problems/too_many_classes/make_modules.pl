#!/usr/bin/env perl

use v5.10;



#my $max = 1000;
#make_modules($max);



### clean up after yourself
#del_modules();


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
sub del_modules {#{{{
    unlink for glob("lib/Loader/*.pm6");
    say "Don't forget to remove the 'use' statements from lib/Loader.pm6.";
}#}}}

