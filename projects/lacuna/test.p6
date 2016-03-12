#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Games::Lacuna;

my $user        = 'tmtowtdi';
my $pass        = 'hi vas';     # THIS IS GETTING CHECKED IN TO GITHUB DON'T USE A REAL PASSWORD HERE
my $server      = 'pt';
my $base_dir    = callframe(0).file.IO.dirname.IO.absolute.IO;


### Create account object.  This does not log you in.
###
### Named args, so either version works.
###
### At this point, I'm not seeing any way for module code located in another 
### file to determine the path to this file (there's no FindBin yet).  So for 
### now at least, I'm going to require passing in the $base_dir.
#my $a = Games::Lacuna::Account.new(:$user, :$pass, :$server, :$base_dir);
my $a = Games::Lacuna::Account.new(:$server, :$user, :$pass, :$base_dir);

say $a.config_file;
exit;


### This does log you in.  I'm not saving the session ID anywhere at this 
### point, so each run of this re-logs-in.
$a.login();
say "After logging in, my session ID is: {$a.session_id}";


### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

