#!/usr/bin/env perl6

use Config::TOML;


my $config_file = 'lacuna.cfg';


if False {   # Read
    my $cfg = slurp $config_file;
    my %toml = from-toml($cfg);
    say %toml;
    say %toml<DEFAULT><api_key>;

}
if False {   # Write
    my %hash = (
        :fname('Jon'),
        :lname('Barton'),
        :colors( <red green orange yellow> ),
        :likes( {:language('perl'), :food('pizza')} )
    );
    say to-toml(%hash);
}
if True {   # Read, modify, re-write
    my $cfg = slurp $config_file;
    my %toml = from-toml($cfg);

    %toml{'pt'}{'session_id'} = time;

    spurt $config_file, to-toml(%toml) ~ "\n";
    #my $fh = $config_file.IO.open :w;
    #$fh.say( to-toml(%toml) );
}

