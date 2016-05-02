#!/usr/bin/env perl6

use Config::TOML;


my $config_file = 'lacuna.cfg';


my $cfg = slurp $config_file;
my %toml = from-toml($cfg);
say %toml;

