#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Games::Lacuna;

my $base_dir        = callframe(0).file.IO.dirname.IO.absolute.IO;
my $config_section  = <pt_sitter>;


### Create account object.  This does not log you in.
my $a = Games::Lacuna::Account.new( :$base_dir, :$config_section );


### This logs you in.
say "Logging in";
$a.login();
say "I am logged in to {$a.empire_name} whose ID is {$a.empire_id}.  My alliance ID is {$a.alliance_id} and my session ID is {$a.session_id}.";
#say "I own the following colonies: {$a.mycolonies<ids>.keys}";
#say "I own the following stations: {$a.mystations<ids>.keys}";
#say "My alliance owns the following stations: {$a.ourstations<ids>.keys}";
''.say;
exit;


### Log out
#say "Logging out.";
#$a.logout;
#exit;


### Get my public profile (23598 is me on PT.)
my $profile = Games::Lacuna::Model::PublicProfile.new(:account($a), :empire_id(23598));
#say "ID: " ~ $profile.id;
say "Name: " ~ $profile.name;
#say "Founded on: " ~ $profile.date_founded.Date;
#say "Most recently logged in: {$profile.last_login.in-timezone(-14400)}.";
### Profile.alliance gives full access to the member's alliance object.
say "{$profile.name} is a member of {$profile.alliance.name}";
exit




### Get my private profile (MUST BE USING YOUR FULL PASSWORD, NOT SITTER)
### I have not done an exhaustive check of all attributes here.  Typos are 
### possible.
#my $profile = Games::Lacuna::Model::PrivateProfile.new(:account($a));
#say $profile.endpoint_name;
#say $profile.skip_facebook_wall_posts;
#say $profile.skip_incoming_ships;
#say $profile.skip_happiness_warnings;
#say $profile.email;
#say $profile.sitter_password;
#say "MEDALS";
#for $profile.medals -> $m {
#    if $m.name ~~ m:i/'of the week'/ {
#        say "\tThe {$m.name} medal has been earned {$m.times_earned} times, first on {$m.date}.  This medal is{' not' unless $m.public} public.";
#    }
#}
#exit;



### Get my alliance profile
### Constructor dies if you're not in an alliance.
#my $sma = Games::Lacuna::Model::Alliance.new(:account($a));
#say "{$sma.name} is described as {$sma.description} and currently exerts {$sma.influence} influence.";
#say "MEMBERS:";
#for $sma.members -> $m {
#    say "\t{$m.name} has ID {$m.id}.";
#}
#say "SSs:";
#for $sma.space_stations -> $ss {
#    say "\t{$ss.name} has ID {$ss.id} and lives at ({$ss.x}, {$ss.y}).";
#}
#''.say;

### Get another alliance's profile by ID
#my $culture = Games::Lacuna::Model::Alliance.new(:account($a), :alliance_id(26));
#say "{$culture.name} is described as {$culture.description} and currently exerts {$culture.influence} influence.";
#say "MEMBERS:";
#for $culture.members -> $m {
#    say "\t{$m.name} has ID {$m.id}.";
#}
#say "SSs:";
#for $culture.space_stations -> $ss {
#    say "\t{$ss.name} has ID {$ss.id} and lives at ({$ss.x}, {$ss.y}).";
#}
#''.say;
#exit;



### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

