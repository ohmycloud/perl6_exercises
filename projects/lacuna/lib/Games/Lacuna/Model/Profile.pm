
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;
use Games::Lacuna::Model::Alliance;
use Games::Lacuna::Model::Body;
use Games::Lacuna::Model::Medal;


role Games::Lacuna::Model::Profile::ProfileRole does Games::Lacuna::Model {#{{{
    has Int $.id;
    has Str $.name;
    has Str $.colony_count;
    has Str $.status_message;
    has Str $.description;
    has Str $.city;
    has Str $.country;
    has Str $.skype;
    has Str $.player_name;
    has Str $.species;
    has Games::Lacuna::Model::Medal @.medals;
    has Games::Lacuna::DateTime $.last_login;
    has Games::Lacuna::DateTime $.date_founded;
    has Games::Lacuna::Model::Alliance::FullAlliance $.alliance;
    has Games::Lacuna::Model::Body::ForeignPlanet @.known_colonies;

    method id               { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method name             { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
    method colony_count     { return $!colony_count if defined $!colony_count or not defined %.json<colony_count>; $!colony_count = %.json<colony_count>; }
    method status_message   { return $!status_message if defined $!status_message or not defined %.json<status_message>; $!status_message = %.json<status_message>; }
    method description      { return $!description if defined $!description or not defined %.json<description>; $!description = %.json<description>; }
    method city             { return $!city if defined $!city or not defined %.json<city>; $!city = %.json<city>; }
    method country          { return $!country if defined $!country or not defined %.json<country>; $!country = %.json<country>; }
    method skype            { return $!skype if defined $!skype or not defined %.json<skype>; $!skype = %.json<skype>; }
    method player_name      { return $!player_name if defined $!player_name or not defined %.json<player_name>; $!player_name = %.json<player_name>; }
    method last_login       { return $!last_login if defined $!last_login or not defined %.json<last_login>; $!last_login = Games::Lacuna::DateTime.from_tle(%.json<last_login>); }
    method date_founded     { return $!date_founded if defined $!date_founded or not defined %.json<date_founded>; $!date_founded = Games::Lacuna::DateTime.from_tle(%.json<date_founded>); }

    method alliance {#{{{
        return $!alliance if defined $!alliance or not defined %.json<alliance>;
        $!alliance = Games::Lacuna::Model::Alliance.new(:account($.account), :alliance_id(%.json<alliance><id>));
    }#}}}
    method medals {#{{{
        return @!medals if @!medals.elems > 0 or not defined %.json<medals>;
        for %.json<medals>.kv -> $id, %m {
            %m<id> = $id;
            @!medals.push( Games::Lacuna::Model::Medal.new(:json(%m)) );
        }
        @!medals;
   }#}}}
    method known_colonies {#{{{
        return @!known_colonies if @!known_colonies.elems > 0 or not defined %.json<known_colonies>;
        for %.json<known_colonies>.values -> %c {
            @!known_colonies.push( Games::Lacuna::Model::Body.new(:planet_hash(%c)) );
        }
        @!known_colonies;
   }#}}}

}#}}}

#|{
    The publicly-viewable portion of a player's profile.
            my $p = Games::Lacuna::Model::PublicProfile.new( :account($a), :empire_id(12345) );
#}
class Games::Lacuna::Model::Profile::PublicProfile does Games::Lacuna::Model::Profile::ProfileRole {#{{{
    submethod BUILD (:$account, :$empire_id) {
        $!account       = $account;
        $!endpoint_name = 'empire';
        my %rv          = $!account.send(
            :$!endpoint_name, :method('view_public_profile'),
            [$!account.session_id, $empire_id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><profile>;
    }
}#}}}

#|{
    The portion of a player's profile only visible to that player.
    You must be logged in with your real password, not your sitter.  Throws 
    exception if you're on your sitter.

    You don't need to pass an empire_id for this, since the method can only be 
    called for the currently-logged-in empire:
            my $p = Games::Lacuna::Model::PrivateProfile.new( :account($a) );
#}
class Games::Lacuna::Model::Profile::PrivateProfile does Games::Lacuna::Model::Profile::ProfileRole {#{{{
    has Bool $.skip_happiness_warnings;
    has Bool $.skip_resource_warnings;
    has Bool $.skip_pollution_warnings;
    has Bool $.skip_medal_messages;
    has Bool $.skip_facebook_wall_posts;
    has Bool $.skip_found_nothing;
    has Bool $.skip_excavator_resources;
    has Bool $.skip_excavator_glyph;
    has Bool $.skip_excavator_plan;
    has Bool $.skip_spy_recovery;
    has Bool $.skip_probe_detected;
    has Bool $.skip_attack_messages;
    has Bool $.skip_incoming_ships;
    has Str $.email;
    has Str $.sitter_password;

    submethod BUILD (:$account) {
        $!account       = $account;
        $!endpoint_name = 'empire';
        $!id            = $!account.empire_id.Int;
        my %rv          = $!account.send(
            :$!endpoint_name, :method('view_profile'),
            [$account.session_id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><profile>;
    }

    method skip_happiness_warnings  { return $!skip_happiness_warnings if defined $!skip_happiness_warnings or not defined %.json<skip_happiness_warnings>; $!skip_happiness_warnings = %.json<skip_happiness_warnings>.Bool; }
    method skip_resource_warnings   { return $!skip_resource_warnings if defined $!skip_resource_warnings or not defined %.json<skip_resource_warnings>; $!skip_resource_warnings = %.json<skip_resource_warnings>.Bool; }
    method skip_pollution_warnings  { return $!skip_pollution_warnings if defined $!skip_pollution_warnings or not defined %.json<skip_pollution_warnings>; $!skip_pollution_warnings = %.json<skip_pollution_warnings>.Bool; }
    method skip_medal_messages      { return $!skip_medal_messages if defined $!skip_medal_messages or not defined %.json<skip_medal_messages>; $!skip_medal_messages = %.json<skip_medal_messages>.Bool; }
    method skip_facebook_wall_posts { return $!skip_facebook_wall_posts if defined $!skip_facebook_wall_posts or not defined %.json<skip_facebook_wall_posts>; $!skip_facebook_wall_posts = %.json<skip_facebook_wall_posts>.Bool; }
    method skip_found_nothing       { return $!skip_found_nothing if defined $!skip_found_nothing or not defined %.json<skip_found_nothing>; $!skip_found_nothing = %.json<skip_found_nothing>.Bool; }
    method skip_excavator_resources { return $!skip_excavator_resources if defined $!skip_excavator_resources or not defined %.json<skip_excavator_resources>; $!skip_excavator_resources = %.json<skip_excavator_resources>.Bool; }
    method skip_excavator_glyph     { return $!skip_excavator_glyph if defined $!skip_excavator_glyph or not defined %.json<skip_excavator_glyph>; $!skip_excavator_glyph = %.json<skip_excavator_glyph>.Bool; }
    method skip_excavator_plan      { return $!skip_excavator_plan if defined $!skip_excavator_plan or not defined %.json<skip_excavator_plan>; $!skip_excavator_plan = %.json<skip_excavator_plan>.Bool; }
    method skip_spy_recovery        { return $!skip_spy_recovery if defined $!skip_spy_recovery or not defined %.json<skip_spy_recovery>; $!skip_spy_recovery = %.json<skip_spy_recovery>.Bool; }
    method skip_probe_detected      { return $!skip_probe_detected if defined $!skip_probe_detected or not defined %.json<skip_probe_detected>; $!skip_probe_detected = %.json<skip_probe_detected>.Bool; }
    method skip_attack_messages     { return $!skip_attack_messages if defined $!skip_attack_messages or not defined %.json<skip_attack_messages>; $!skip_attack_messages = %.json<skip_attack_messages>.Bool; }
    method skip_incoming_ships      { return $!skip_incoming_ships if defined $!skip_incoming_ships or not defined %.json<skip_incoming_ships>; $!skip_incoming_ships = %.json<skip_incoming_ships>.Bool; }
    method email                    { return $!email if defined $!email or not defined %.json<email>; $!email = %.json<email>; }
    method sitter_password          { return $!sitter_password if defined $!sitter_password or not defined %.json<sitter_password>; $!sitter_password = %.json<sitter_password>; }

}#}}}



#|{
    Profile Factory.

    Returns either a public profile or a private profile.  The private profile 
    can only be returned for the current account, and only when that account 
    has been logged in using its full, not sitter, password.

    Examples:
            my $pub_profile  = Games::Lacuna::Model::Profile.new(:account($a), :empire_id(23598));
            my $priv_profile = Games::Lacuna::Model::Profile.new(:account($a));
}
class Games::Lacuna::Model::Profile {
    multi method new (:$account!, :$empire_id!) {#{{{
        return Games::Lacuna::Model::Profile::PublicProfile.new(:$account, :$empire_id);
    }#}}}
    multi method new (:$account!) {#{{{
        return Games::Lacuna::Model::Profile::PrivateProfile.new(:$account);
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

