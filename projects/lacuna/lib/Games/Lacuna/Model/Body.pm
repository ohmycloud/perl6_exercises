
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

### This needs to be a factory.  Types of bodies:
###     planet - own
###     planet - foreign
###     star
###     asteroid
###     ss - own
###     ss - foreign
class Games::Lacuna::Model::Body does Games::Lacuna::Model {#{{{
    has %.p;                        # convenience -- just %.json_parsed<result><body>.  Handled by BUILD.

    #|{
    #}
    proto method BUILD (:$account!, :$body_id) {#{{{
        {*};
        $!account       = $account;
        $!endpoint_name = 'body';
        %!json_parsed   = $account.send(
            :$!endpoint_name, :method('view_profile'),
            [$account.session_id, $!id]
        );
        die Games::Lacuna::Exception.new(%!json_parsed) if %!json_parsed<error>;
        try { %!p = %!json_parsed<result><profile> };
    }#}}}
    multi submethod BUILD (:$account!, :$alliance_id!) {#{{{
        $!id = $alliance_id;
    }#}}}
    multi submethod BUILD (:$account!) {#{{{
        $!id = $account.alliance_id;
    }#}}}

}#}}}

role Games::Lacuna::Model::BodyRole does Games::Lacuna::Model {#{{{
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

    ### CHECK - need classes
    #has Ore $.ore;
    #has SS $.station;          # won't show up if body not under SS control

}#}}}

class Games::Lacuna::Model::Body::ForeignPlanet does Games::Lacuna::Model::BodyRole {#{{{
}#}}}
class Games::Lacuna::Model::Body::OwnPlanet does Games::Lacuna::Model::BodyRole {#{{{
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
    has Int $.skip_incoming_ships;
    has Int $.num_incoming_ships;
    has Int $.num_incoming_ally;
    has Int $.num_incoming_own;

    has Games::Lacuna::DateTime $.unhappy_date;
    has Games::Lacuna::DateTime $.neutral_entry;

    ### CHECK - need classes
    #has Empire $.empire;
    #has Ships $.incoming_enemy_ships;
    #has Ships $.incoming_ally_ships;
    #has Ships $.incoming_own_ships;
}#}}}
class Games::Lacuna::Model::Body::SS does Games::Lacuna::Model::BodyRole {#{{{
    ### CHECK - need classes
    #has Alliance $.alliance;
    #has Influence $.influence;
}#}}}

 # vim: syntax=perl6 fdm=marker

