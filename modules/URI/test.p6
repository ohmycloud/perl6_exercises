#!/usr/bin/env perl6

use URI;


### works


my URI $u .= new('http://www.example.com/path/to/resource.html?query=string&fname=jon#extra');

say $u.scheme;
say $u.authority;
say $u.host;
say $u.port;
say $u.path;
say $u.query;
say $u.frag;
say $u.query-form<fname>;
''.say;


use URI::Escape;
my $esc = uri-escape("10% is enough\n");
my $unesc = uri-unescape($esc);
say $esc;
say $unesc;

