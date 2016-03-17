
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

###
### This needs to be a factory.  Types of bodies:
###     planet - own
###     planet - foreign
###     star
###     asteroid
###         Not sure if either star or asteroid are going to end up here.
###     ss - own
###         pretty sure this should include SSs I specifically own as well as 
###         SSs owned by anybody in my alliance.
###     ss - foreign
###         SSs owned by "not my alliance". 
###
### 
###
###
### Body classes are mostly for dealing with your own planets. 
###
### But a lot of server responses contain a small subset of planet data.  eg a 
### PublicProfile contains a list of a user's known_colonies.  These 
### known_colonies will become a list of ForeignBody objects.
###
class Games::Lacuna::Model::Body {#{{{

    multi method new (:$account!, :$body_name!) {#{{{
        return Games::Lacuna::Model::Body::OwnPlanet.new(:$account, $account.mycolonies<names>{$body_name})    if $account.mycolonies<names>{$body_name};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account, $account.mystations<names>{$body_name})        if $account.mystations<names>{$body_name};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account, $account.ourstations<names>{$body_name})       if $account.ourstations<names>{$body_name};
        die "You can only access a body by name if you own it.";
    }#}}}
    multi method new (:$account!, :$body_id!) {#{{{
        return Games::Lacuna::Model::Body::OwnPlanet.new(:$account, $account.mycolonies<ids>{$body_id})    if $account.mycolonies<ids>{$body_id};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account, $account.mystations<ids>{$body_id})        if $account.mystations<ids>{$body_id};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account, $account.ourstations<ids>{$body_id})       if $account.ourstations<ids>{$body_id};
        die "You can only access a body by ID if you own it.";
    }#}}}
    multi method new (:%planet_hash!) {#{{{
        return Games::Lacuna::Model::Body::ForeignPlanet.new(:%planet_hash);
    }#}}}
    multi method new (:%station_hash!) {#{{{
        return Games::Lacuna::Model::Body::ForeignSS.new(:%station_hash);
    }#}}}


}#}}}

role Games::Lacuna::Model::Body::BodyRole {#{{{
    has %.p;                        # convenience -- just %.json_parsed<result><body>.  Handled by BUILD.
    has Int $.id;
    has Int $.x;
    has Int $.y;
    has Int $.star_id;
    has Int $.orbit;
    has Int $.size;
    has Int $.water;
    has Str $.star_name;
    has Str $.type;
    has Str $.name;
    has Str $.image;

    ### CHECK - need classes and accessor methods
    #has Ore $.ore;
    #has SS $.station;          # won't show up if body not under SS control

    method id           { return $!id if defined $!id or not defined %!p<id>; $!id = %!p<id>.Int; }
    method x            { return $!x if defined $!x or not defined %!p<x>; $!x = %!p<x>.Int; }
    method y            { return $!y if defined $!y or not defined %!p<y>; $!y = %!p<y>.Int; }
    method star_id      { return $!star_id if defined $!star_id or not defined %!p<star_id>; $!star_id = %!p<star_id>.Int; }
    method orbit        { return $!orbit if defined $!orbit or not defined %!p<orbit>; $!orbit = %!p<orbit>.Int; }
    method size         { return $!size if defined $!size or not defined %!p<size>; $!size = %!p<size>.Int; }
    method water        { return $!water if defined $!water or not defined %!p<water>; $!water = %!p<water>.Int; }
    method star_name    { return $!star_name if defined $!star_name or not defined %!p<star_name>; $!star_name = %!p<star_name>; }
    method type         { return $!type if defined $!type or not defined %!p<type>; $!type = %!p<type>; }
    method name         { return $!name if defined $!name or not defined %!p<name>; $!name = %!p<name>; }
    method image        { return $!image if defined $!image or not defined %!p<image>; $!image = %!p<image>; }

}#}}}
role Games::Lacuna::Model::Body::OwnBodyRole does Games::Lacuna::Model does Games::Lacuna::Model::Body::BodyRole {#{{{
    has Int $.needs_surface_refresh;
    has Int $.building_count;
    has Int $.build_queue_size;
    has Int $.build_queue_len;
    has Int $.plots_available;
    has Int $.happiness;
    has Int $.happiness_hour;
    has Int $.propaganda_boost;
    has Int $.food_stored;
    has Int $.food_hour;
    has Int $.food_capacity;
    has Int $.energy_stored;
    has Int $.energy_hour;
    has Int $.energy_capacity;
    has Int $.ore_stored;
    has Int $.ore_hour;
    has Int $.ore_capacity;
    has Int $.waste_stored;
    has Int $.waste_hour;
    has Int $.waste_capacity;
    has Int $.water_stored;
    has Int $.water_hour;
    has Int $.water_capacity;
    has Bool $.skip_incoming_ships;
    has Int $.num_incoming_enemy;
    has Int $.num_incoming_ally;
    has Int $.num_incoming_own;

    has Games::Lacuna::DateTime $.unhappy_date;
    has Games::Lacuna::DateTime $.neutral_entry;     # Earliest date this body can enter the NZ

    ### CHECK - need classes
    #has Empire $.empire;
    #has Ships $.incoming_enemy_ships;
    #has Ships $.incoming_ally_ships;
    #has Ships $.incoming_own_ships;

    method needs_surface_refresh           { return $!needs_surface_refresh if defined $!needs_surface_refresh or not defined %.p<needs_surface_refresh>; $!needs_surface_refresh = %.p<needs_surface_refresh>.Int; }
    method building_count           { return $!building_count if defined $!building_count or not defined %.p<building_count>; $!building_count = %.p<building_count>.Int; }
    method build_queue_size           { return $!build_queue_size if defined $!build_queue_size or not defined %.p<build_queue_size>; $!build_queue_size = %.p<build_queue_size>.Int; }
    method build_queue_len           { return $!build_queue_len if defined $!build_queue_len or not defined %.p<build_queue_len>; $!build_queue_len = %.p<build_queue_len>.Int; }
    method plots_available           { return $!plots_available if defined $!plots_available or not defined %.p<plots_available>; $!plots_available = %.p<plots_available>.Int; }
    method happiness           { return $!happiness if defined $!happiness or not defined %.p<happiness>; $!happiness = %.p<happiness>.Int; }
    method happiness_hour           { return $!happiness_hour if defined $!happiness_hour or not defined %.p<happiness_hour>; $!happiness_hour = %.p<happiness_hour>.Int; }
    method propaganda_boost           { return $!propaganda_boost if defined $!propaganda_boost or not defined %.p<propaganda_boost>; $!propaganda_boost = %.p<propaganda_boost>.Int; }
    method food_stored           { return $!food_stored if defined $!food_stored or not defined %.p<food_stored>; $!food_stored = %.p<food_stored>.Int; }
    method food_hour           { return $!food_hour if defined $!food_hour or not defined %.p<food_hour>; $!food_hour = %.p<food_hour>.Int; }
    method food_capacity           { return $!food_capacity if defined $!food_capacity or not defined %.p<food_capacity>; $!food_capacity = %.p<food_capacity>.Int; }
    method energy_stored           { return $!energy_stored if defined $!energy_stored or not defined %.p<energy_stored>; $!energy_stored = %.p<energy_stored>.Int; }
    method energy_hour           { return $!energy_hour if defined $!energy_hour or not defined %.p<energy_hour>; $!energy_hour = %.p<energy_hour>.Int; }
    method energy_capacity           { return $!energy_capacity if defined $!energy_capacity or not defined %.p<energy_capacity>; $!energy_capacity = %.p<energy_capacity>.Int; }
    method ore_stored           { return $!ore_stored if defined $!ore_stored or not defined %.p<ore_stored>; $!ore_stored = %.p<ore_stored>.Int; }
    method ore_hour           { return $!ore_hour if defined $!ore_hour or not defined %.p<ore_hour>; $!ore_hour = %.p<ore_hour>.Int; }
    method ore_capacity           { return $!ore_capacity if defined $!ore_capacity or not defined %.p<ore_capacity>; $!ore_capacity = %.p<ore_capacity>.Int; }
    method waste_stored           { return $!waste_stored if defined $!waste_stored or not defined %.p<waste_stored>; $!waste_stored = %.p<waste_stored>.Int; }
    method waste_hour           { return $!waste_hour if defined $!waste_hour or not defined %.p<waste_hour>; $!waste_hour = %.p<waste_hour>.Int; }
    method waste_capacity           { return $!waste_capacity if defined $!waste_capacity or not defined %.p<waste_capacity>; $!waste_capacity = %.p<waste_capacity>.Int; }
    method water_stored           { return $!water_stored if defined $!water_stored or not defined %.p<water_stored>; $!water_stored = %.p<water_stored>.Int; }
    method water_hour           { return $!water_hour if defined $!water_hour or not defined %.p<water_hour>; $!water_hour = %.p<water_hour>.Int; }
    method water_capacity           { return $!water_capacity if defined $!water_capacity or not defined %.p<water_capacity>; $!water_capacity = %.p<water_capacity>.Int; }

    method unhappy_date     { return $!unhappy_date if defined $!unhappy_date or not defined %.p<unhappy_date>; $!unhappy_date = Games::Lacuna::DateTime.from_tle(%.p<unhappy_date>); }
    method neutral_entry    { return $!neutral_entry if defined $!neutral_entry or not defined %.p<neutral_entry>; $!neutral_entry = Games::Lacuna::DateTime.from_tle(%.p<neutral_entry>); }

    ### If skip_incoming_ships is set, the following four num_* attributes 
    ### will not be sent.
    method skip_incoming_ships  { return $!skip_incoming_ships if defined $!skip_incoming_ships or not defined %.p<skip_incoming_ships>; $!skip_incoming_ships = %.p<skip_incoming_ships>.Int.Bool; }
    method num_incoming_enemy   { return $!num_incoming_enemy if defined $!num_incoming_enemy or not defined %.p<num_incoming_enemy>; $!num_incoming_enemy = %.p<num_incoming_enemy>.Int; }
    method num_incoming_ally    { return $!num_incoming_ally if defined $!num_incoming_ally or not defined %.p<num_incoming_ally>; $!num_incoming_ally = %.p<num_incoming_ally>.Int; }
    method num_incoming_own     { return $!num_incoming_own if defined $!num_incoming_own or not defined %.p<num_incoming_own>; $!num_incoming_own = %.p<num_incoming_own>.Int; }
 
    ### CHECK fix
    #method incoming_enemy_ships           { return $!incoming_enemy_ships if defined $!incoming_enemy_ships or not defined %.p<incoming_enemy_ships>; $!incoming_enemy_ships = %.p<incoming_enemy_ships>.Int; }
    #method incoming_ally_ships           { return $!incoming_ally_ships if defined $!incoming_ally_ships or not defined %.p<incoming_ally_ships>; $!incoming_ally_ships = %.p<incoming_ally_ships>.Int; }
    #method incoming_own_ships           { return $!incoming_own_ships if defined $!incoming_own_ships or not defined %.p<incoming_own_ships>; $!incoming_own_ships = %.p<incoming_own_ships>.Int; }

}#}}}
role Games::Lacuna::Model::Body::ForeignBodyRole does Games::Lacuna::NonCommModel does Games::Lacuna::Model::Body::BodyRole {#{{{
}#}}}
role Games::Lacuna::Model::Body::SSRole {#{{{
    ### CHECK - need classes
    #has Alliance $.alliance;
    #has Influence $.influence;
}#}}}

class Games::Lacuna::Model::Body::OwnPlanet does Games::Lacuna::Model::Body::OwnBodyRole {#{{{
    submethod BUILD (:$account, :$body_id) {
        $!account       = $account;
        $!endpoint_name = 'body';
        %!json_parsed   = $!account.send(
            :$!endpoint_name, :method('get_status'),
            ($!account.session_id, $body_id)
        );
        die Games::Lacuna::Exception.new(%!json_parsed) if %!json_parsed<error>;
        try { %!p = %!json_parsed<result><profile> };
    }
}#}}}
class Games::Lacuna::Model::Body::OwnSS does Games::Lacuna::Model::Body::SSRole does Games::Lacuna::Model::Body::OwnBodyRole {#{{{
    submethod BUILD (:$account, :$body_id) {
        $!account       = $account;
        $!endpoint_name = 'body';
        %!json_parsed   = $!account.send(
            :$!endpoint_name, :method('get_status'),
            ($!account.session_id, $body_id)
        );
        die Games::Lacuna::Exception.new(%!json_parsed) if %!json_parsed<error>;
        try { %!p = %!json_parsed<result><profile> };
    }
}#}}}

class Games::Lacuna::Model::Body::ForeignPlanet does Games::Lacuna::Model::Body::ForeignBodyRole {#{{{
    submethod BUILD (:%planet_hash) {
        %!json_parsed   = %planet_hash;
        %!p             = %planet_hash;
    }
}#}}}
class Games::Lacuna::Model::Body::ForeignSS does Games::Lacuna::Model::Body::ForeignBodyRole does Games::Lacuna::Model::Body::SSRole {#{{{
    submethod BUILD (:%station_hash) {
        %!json_parsed   = %station_hash;
        %!p             = %station_hash;
    }
}#}}}

 # vim: syntax=perl6 fdm=marker

