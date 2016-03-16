#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Games::Lacuna;

my $base_dir        = callframe(0).file.IO.dirname.IO.absolute.IO;
my $config_section  = <real>;


### Create account object.  This does not log you in.
my $a = Games::Lacuna::Account.new( :$base_dir, :$config_section );


### This logs you in.
say "Logging in";
$a.login();
say "I am logged in to {$a.empire_name} whose ID is {$a.empire_id}.  My alliance ID is {$a.alliance_id} and my session ID is {$a.session_id}.";
''.say;


### Get my public profile (23598 is me on PT.)
#my $profile = Games::Lacuna::Model::PublicProfile.new(:account($a), :empire_id(23598));
#say "ID: " ~ $profile.id;
#say "Name: " ~ $profile.name;
#say "Founded on: " ~ $profile.date_founded.Date;
#say "Most recently logged in: {$profile.last_login.in-timezone(-14400)}.";
#exit;


### Get my private profile (MUST BE USING YOUR FULL PASSWORD, NOT SITTER)
### I have not done an exhaustive check of all attributes here.  Typos are 
### possible.
my $profile = Games::Lacuna::Model::PrivateProfile.new(:account($a));
#say $profile.endpoint_name;
#say $profile.skip_facebook_wall_posts;
#say $profile.skip_incoming_ships;
#say $profile.skip_happiness_warnings;
#say $profile.email;
#say $profile.sitter_password;
say "MEDALS";
for $profile.medals -> $m {
    if $m.name ~~ m:i/'of the week'/ {
        say "\tThe {$m.name} medal has been earned {$m.times_earned} times, first on {$m.date}.  This medal is{' not' unless $m.public} public.";
    }
}
#exit;




### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

