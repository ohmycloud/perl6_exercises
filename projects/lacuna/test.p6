#!/usr/bin/env perl6

use v6;
use lib 'lib';
use File::Temp;
use Games::Lacuna;



my $base_dir        = callframe(0).file.IO.dirname.IO.absolute.IO;
#my $config_section  = <pt_real>;
my $config_section  = <pt_sitter>;
#my $config_section  = <us1_sitter>;



### Create account object.  This does not log you in.
my $a = Games::Lacuna::Account.new( :$base_dir, :$config_section );


### This logs you in.
say "Logging in using config section $config_section.";
$a.login();
say "I am logged in to {$a.empire_name} whose ID is {$a.empire_id}.  My alliance ID is {$a.alliance_id} and my session ID is {$a.session_id}.";
#say "I own the following colonies: {$a.mycolonies<ids>.keys}";
#say "I own the following stations: {$a.mystations<ids>.keys}";
#say "My alliance owns the following stations: {$a.ourstations<ids>.keys}";
''.say;
#exit;


### Get and display a captcha image, check the solution.
#my $c = Games::Lacuna::Model::Captcha.new( :account($a) );
#say "Calling fetch";
#$c.fetch;
#my ($fn, $fh) = tempfile(:!unlink);
#$c.save($fn);
#shell("xdg-open $fn");     # obviously not portable but fine for a test script.
#print "I just opened a captcha image.  Enter the solution here: ";
#my $resp = $*IN.get();
#$fn.IO.unlink;
#say $c.solve($resp) ?? "Correct!" !! "BRRRRZZZT!";
#exit;


### Log out
#say "Logging out.";
#$a.logout;
#exit;


### Get my public profile (23598 is me on PT.)
#my $pub_profile = Games::Lacuna::Model::Profile.new(:account($a), :empire_id(23598));
#say "ID: " ~ $pub_profile.id;
#say "Name: " ~ $pub_profile.name;
#say "Founded on: " ~ $pub_profile.date_founded.Date;
#say "Most recently logged in: {$pub_profile.last_login.in-timezone(-14400)}.";
### Profile.alliance gives full access to the member's alliance object.
#say "{$pub_profile.name} is a member of {$pub_profile.alliance.name}";
#say "KNOWN COLONIES";
#for $pub_profile.known_colonies -> $c {
#    say "\t{$c.name} has ID {$c.id} and lives at ({$c.x}, {$c.y}).";
#}
#''.say;
#exit;



### Get my private profile (MUST BE USING YOUR FULL PASSWORD, NOT SITTER)
### I have not done an exhaustive check of all attributes here.  Typos are 
### possible.
#my $priv_profile = Games::Lacuna::Model::Profile.new(:account($a));
#say $priv_profile.endpoint_name;
#say $priv_profile.skip_facebook_wall_posts;
#say $priv_profile.skip_incoming_ships;
#say $priv_profile.skip_happiness_warnings;
#say $priv_profile.email;
#say $priv_profile.sitter_password;
#say "MEDALS";
#for $priv_profile.medals -> $m {
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



### Bodies
###
### Get my...
###
### ...planet by name
#my $p1 = Games::Lacuna::Model::Body.new( :account($a), :body_name('bmots07') );
#say "{$p1.name} has ID {$p1.id} and lives at ({$p1.x}, {$p1.y}).";

### ...planet by ID (bmots07 again)
#my $p2 = Games::Lacuna::Model::Body.new( :account($a), :body_id('360565') );
#say "{$p2.name} has ID {$p2.id} and lives at ({$p2.x}, {$p2.y}).";

### ...station by name
#my $s1 = Games::Lacuna::Model::Body.new( :account($a), :body_name('SASS bmots 01') );
#say "{$s1.name} has ID {$s1.id} and lives at ({$s1.x}, {$s1.y}).";

### ..station by ID (SASS bmots 01 again)
#my $s2 = Games::Lacuna::Model::Body.new( :account($a), :body_id(468709) );
#say "{$s2.name} has ID {$s2.id} and lives at ({$s2.x}, {$s2.y}).";
#''.say;
#exit;

### More body testing
if False {# {{{
    
    my $p = Games::Lacuna::Model::Body.new( :account($a), :body_name('bmots07') );
    say "{$p.empire.name} is me.  Alignment is '{$p.empire.alignment}'.";     # alignment == 'self'
    say "{$p.name} has concentrations of {$p.ore<gold>} gold and {$p.ore<bauxite>} bauxite.";
    say "{$p.name} is under the control of {$p.station.name}." if $p.station;
    unless $p.skip_incoming_ships {
        ### No incoming ships will be shown if .skip_incoming_ships is True.
        for $p.incoming_own_ships -> $s {
            say "Ship {$s.id} will arrive on {$s.date_arrives}.";
        }
        ### .incoming_own_ships is easiest to test by just sending yourself a 
        ### smuggler, but incoming_enemy_ships and incoming_ally_ships both work 
        ### the same way.
    }


    my $s = Games::Lacuna::Model::Body.new( :account($a), :body_name('SASS bmots 01') );
    say "{$s.name} is controlled by {$s.alliance.name}.";
    say "{$s.name} is exerting {$s.influence.spent} of its total {$s.influence.total} influence.";

}# }}}




