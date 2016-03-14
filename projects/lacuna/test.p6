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


### spit out the config file name and exit.  I often use this to test.
#say $a.config_file;
#exit;


### Log in.
$a.login();
say "I am logged in to {$a.empire_name} whose ID is {$a.empire_id}.  My alliance ID is {$a.alliance_id} and my session ID is {$a.session_id}.";
''.say;


### Get my public profile (23598 is me on PT.)
my $profile = Games::Lacuna::PublicProfile.new(:account($a), :empire_id(23598));
say "ID: " ~ $profile.id;
say "Name: " ~ $profile.name;
exit;


### Get my private profile (MUST BE USING YOUR FULL PASSWORD, NOT SITTER)
### Does work if you're on your full.
### I have not done an exhaustive check of all attributes here.  Typos are 
### possible.
#my $profile = Games::Lacuna::PrivateProfile.new(:account($a));
#say $profile.endpoint_name;
#say $profile.skip_facebook_wall_posts;
#say $profile.skip_incoming_ships;
#say $profile.skip_happiness_warnings;
#say $profile.email;
#say $profile.sitter_password;
#exit;




### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

