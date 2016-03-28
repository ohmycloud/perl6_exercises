
use Games::Lacuna::Model::Profile::ProfileRole;

#|{
    The portion of a player's profile only visible to that player.
    You must be logged in with your real password, not your sitter.  Throws 
    exception if you're on your sitter.

    You don't need to pass an empire_id for this, since the method can only be 
    called for the currently-logged-in empire:
            my $p = Games::Lacuna::Model::PrivateProfile.new( :account($a) );
#}
class Games::Lacuna::Model::Profile::PrivateProfile does Games::Lacuna::Model::Profile::ProfileRole {#{{{
    use Games::Lacuna::Exception;

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

 # vim: syntax=perl6 fdm=marker

