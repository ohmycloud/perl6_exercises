#!/usr/bin/env perl6


if False {# {{{
    
    class Jontest {# {{{
        has $.config_file;

        proto method config_file(|) {
            say "proto"; 
            {*};
            say "back to proto";
            if $!config_file !~~ :e {   # create the config file if it doesn't already exist.
                my $rv = $!config_file.open(:w);
                $rv.close();
            }
            $!config_file    = IO::Path.new( $!config_file );
            die "$!config_file Cannot write to file." unless $!config_file ~~ :w;
            return $!config_file;
        }
        multi method config_file() {
            say "no args";
            $!config_file   = IO::Path.new( callframe(0).file.IO.dirname ~ '/config/lacuna.cfg' );
            my $dir         = IO::Path.new( $!config_file.dirname );
            $dir.mkdir or die "$dir: Could not create directory.";
        }
        multi method config_file(Str $path) {
            say "path arg";
            $!config_file = IO::Path.new( $path );
        }

    }# }}}
    my $j = Jontest.new();
    $j.config_file;

}# }}}
if True {

    my %c;
    %c<jon> = Nil;
    say defined %c<kermit>;
    say %c<kermit>;
    say defined %c<jon>;
    say %c<jon>;

    if %c<jon> {
        say "true";
    }

}


