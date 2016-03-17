
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;
use Games::Lacuna::Model::Medal;
use Games::Lacuna::Model::Alliance;
use Games::Lacuna::Model::Body;

role Games::Lacuna::Model::Profile does Games::Lacuna::Model {#{{{
    has %.p;                        # convenience -- just %.json_parsed<result><profile>.  Handled by BUILD.
    has Int $.id;
    has Str $.name;
    has Str $.colony_count;
    has Str $.status_message;
    has Str $.description;
    has Str $.city;
    has Str $.country;
    has Str $.skype;
    has Str $.player_name;
    has Games::Lacuna::Model::Medal @.medals;
    has Games::Lacuna::DateTime $.last_login;
    has Games::Lacuna::DateTime $.date_founded;
    has Str $.species;
   has Games::Lacuna::Model::Alliance $.alliance;
#   has Planet $.known_colonies     # CHECK class does not exist;

    method id               { return $!id if defined $!id or not defined %!p<id>; $!id = %!p<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!p<name>; $!name = %!p<name>; }
    method colony_count     { return $!colony_count if defined $!colony_count or not defined %!p<colony_count>; $!colony_count = %!p<colony_count>; }
    method status_message   { return $!status_message if defined $!status_message or not defined %!p<status_message>; $!status_message = %!p<status_message>; }
    method description      { return $!description if defined $!description or not defined %!p<description>; $!description = %!p<description>; }
    method city             { return $!city if defined $!city or not defined %!p<city>; $!city = %!p<city>; }
    method country          { return $!country if defined $!country or not defined %!p<country>; $!country = %!p<country>; }
    method skype            { return $!skype if defined $!skype or not defined %!p<skype>; $!skype = %!p<skype>; }
    method player_name      { return $!player_name if defined $!player_name or not defined %!p<player_name>; $!player_name = %!p<player_name>; }
    method last_login       { return $!last_login if defined $!last_login or not defined %!p<last_login>; $!last_login = Games::Lacuna::DateTime.from_tle(%!p<last_login>); }
    method date_founded     { return $!date_founded if defined $!date_founded or not defined %!p<date_founded>; $!date_founded = Games::Lacuna::DateTime.from_tle(%!p<date_founded>); }

    ### CHECK these need love.
#   method known_colonies   { return $!known_colonies if defined $!known_colonies or not defined %!p<known_colonies>; $!known_colonies = %!p<known_colonies>; }

   method alliance {
        return $!alliance if defined $!alliance or not defined %!p<alliance>;
        $!alliance = Games::Lacuna::Model::Alliance.new(:account($.account), :json_parsed(%!p<alliance><id>));
    }
    method medals {
        return @!medals if @!medals.elems > 0 or not defined %!p<medals>;
        for %!p<medals>.kv -> $id, %m {
            %m<id> = $id;
            @!medals.push( Games::Lacuna::Model::Medal.new(:json_parsed(%m)) );
        }
        @!medals;
   }

}#}}}

#| The publicly-viewable portion of a player's profile
class Games::Lacuna::Model::PublicProfile does Games::Lacuna::Model::Profile {#{{{

    submethod BUILD (:$account, :$empire_id) {
        $!account       = $account;
        $!endpoint_name = 'empire';
        %!json_parsed   = $!account.send(
            :$!endpoint_name, :method('view_public_profile'),
            ($!account.session_id, $empire_id)
        );
        die Games::Lacuna::Exception.new(%!json_parsed) if %!json_parsed<error>;
        try { %!p = %!json_parsed<result><profile> };
    }

}#}}}

#| The portion of a player's profile only visible to that player.
#| You must be logged in with your real password, not your sitter.  Throws exception if you're on your sitter.
class Games::Lacuna::Model::PrivateProfile does Games::Lacuna::Model::Profile {#{{{
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

        %!json_parsed   = $account.send(
            :$!endpoint_name, :method('view_profile'),
            [$account.session_id]
        );
        die Games::Lacuna::Exception.new(%!json_parsed) if %!json_parsed<error>;
        try { %!p = %!json_parsed<result><profile> };
    }

    method skip_happiness_warnings  { return $!skip_happiness_warnings if defined $!skip_happiness_warnings or not defined %!p<skip_happiness_warnings>; $!skip_happiness_warnings = %!p<skip_happiness_warnings>.Bool; }
    method skip_resource_warnings   { return $!skip_resource_warnings if defined $!skip_resource_warnings or not defined %!p<skip_resource_warnings>; $!skip_resource_warnings = %!p<skip_resource_warnings>.Bool; }
    method skip_pollution_warnings  { return $!skip_pollution_warnings if defined $!skip_pollution_warnings or not defined %!p<skip_pollution_warnings>; $!skip_pollution_warnings = %!p<skip_pollution_warnings>.Bool; }
    method skip_medal_messages      { return $!skip_medal_messages if defined $!skip_medal_messages or not defined %!p<skip_medal_messages>; $!skip_medal_messages = %!p<skip_medal_messages>.Bool; }
    method skip_facebook_wall_posts { return $!skip_facebook_wall_posts if defined $!skip_facebook_wall_posts or not defined %!p<skip_facebook_wall_posts>; $!skip_facebook_wall_posts = %!p<skip_facebook_wall_posts>.Bool; }
    method skip_found_nothing       { return $!skip_found_nothing if defined $!skip_found_nothing or not defined %!p<skip_found_nothing>; $!skip_found_nothing = %!p<skip_found_nothing>.Bool; }
    method skip_excavator_resources { return $!skip_excavator_resources if defined $!skip_excavator_resources or not defined %!p<skip_excavator_resources>; $!skip_excavator_resources = %!p<skip_excavator_resources>.Bool; }
    method skip_excavator_glyph     { return $!skip_excavator_glyph if defined $!skip_excavator_glyph or not defined %!p<skip_excavator_glyph>; $!skip_excavator_glyph = %!p<skip_excavator_glyph>.Bool; }
    method skip_excavator_plan      { return $!skip_excavator_plan if defined $!skip_excavator_plan or not defined %!p<skip_excavator_plan>; $!skip_excavator_plan = %!p<skip_excavator_plan>.Bool; }
    method skip_spy_recovery        { return $!skip_spy_recovery if defined $!skip_spy_recovery or not defined %!p<skip_spy_recovery>; $!skip_spy_recovery = %!p<skip_spy_recovery>.Bool; }
    method skip_probe_detected      { return $!skip_probe_detected if defined $!skip_probe_detected or not defined %!p<skip_probe_detected>; $!skip_probe_detected = %!p<skip_probe_detected>.Bool; }
    method skip_attack_messages     { return $!skip_attack_messages if defined $!skip_attack_messages or not defined %!p<skip_attack_messages>; $!skip_attack_messages = %!p<skip_attack_messages>.Bool; }
    method skip_incoming_ships      { return $!skip_incoming_ships if defined $!skip_incoming_ships or not defined %!p<skip_incoming_ships>; $.skip_incoming_ships = %!p<skip_incoming_ships>.Bool; }
    method email                    { return $!email if defined $!email or not defined %!p<email>; $!email = %!p<email>; }
    method sitter_password          { return $!sitter_password if defined $!sitter_password or not defined %!p<sitter_password>; $!sitter_password = %!p<sitter_password>; }

}#}}}



 # vim: syntax=perl6 fdm=marker

