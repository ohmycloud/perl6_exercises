#!/usr/bin/env perl6


=begin pod

    You have a lot of classes (eg ships or buildings in TLE) and want to load 
    them all, and then dynamically instantiate the correct one based on 
    $something.

            my $str = <get ship name from $somewhere>;
            my $ship = Lacuna::Ships::$str.new();

    I'd been using EVAL for this but don't like doing that if it can be 
    avoided.


    I don't completely understand what's happening below, but it works.

=end pod




use lib '.';
my $mod_name    = 'TestMod';
my $file_name   = $mod_name ~ '.pm6';



### This is the use statement that needs to be either commented or 
### un-commented.
#use TestMod;





if False {   # Requires the 'use' TOF be uncommented.# {{{
    my $tm = ::($mod_name).new();
    say $tm.name;
}# }}}
if True {   # Works if the "use" up top is commented or uncommented.# {{{
    require ::($mod_name);
    my $tm = ::($mod_name).new();
    say $tm.name;
}# }}}
if False {   # Requires the 'use' TOF be commented
    require $file_name;
    my $tm = ::('TestMod').new();
    say $tm.name;
}




