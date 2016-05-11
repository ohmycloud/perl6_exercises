#!/usr/bin/env perl6

use Config::Simple;

=begin pod
    Relies on Config::INI and JSON::Pretty for the ini and JSON formats.

    A little rough maybe, but does what I want to do (both read and write ini files.)
=end pod

if True {  # INI file (read existing and re-write) # {{{
    my $filename = 'one.ini';

    my $conf = Config::Simple.read($filename, :f<ini>);
    say $conf<jon><lname>;

    $conf<jon><lname> = 'Smith';
    $conf.write();
}# }}}
if False {  # JSON file (write from scratch) # {{{
    my $filename = 'two.json';

    my $conf = Config::Simple.new( :f<JSON> );      # case matters
    $conf<jon><fname> = 'Jon';
    $conf<jon><lname> = 'Barton';
    $conf<kermit><fname> = 'Kermit';
    $conf<jackson><lname> = 'Jackson';
    $conf.filename = $filename;
    $conf.write;

}# }}}
if False {  # JSON file (read existing and re-write) # {{{
    my $filename = 'two.json';

    my $conf = Config::Simple.read($filename, :f<JSON>);        # case matters
    say $conf<jon><lname>;

    $conf<jon><lname> = 'Smith';
    $conf.write();
}# }}}

