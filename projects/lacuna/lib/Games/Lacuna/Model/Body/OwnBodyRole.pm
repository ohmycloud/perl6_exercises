
use Games::Lacuna::Model;
use Games::Lacuna::Model::Body::BodyRole;
role Games::Lacuna::Model::Body::OwnBodyRole does Games::Lacuna::Model does Games::Lacuna::Model::Body::BodyRole {
    use Games::Lacuna::DateTime;
    use Games::Lacuna::Exception;
    use Games::Lacuna::Model::Body::Empire;
    use Games::Lacuna::Model::Body::IncomingShip;
    use Games::Lacuna::Model::Building::OwnBuilding;

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

    has Games::Lacuna::Model::Body::Empire $.empire;
    has Games::Lacuna::Model::Body::IncomingShip @.incoming_enemy_ships;
    has Games::Lacuna::Model::Body::IncomingShip @.incoming_ally_ships;
    has Games::Lacuna::Model::Body::IncomingShip @.incoming_own_ships;

    has @.buildings;



    method needs_surface_refresh           { return $!needs_surface_refresh if defined $!needs_surface_refresh or not defined %.json<needs_surface_refresh>; $!needs_surface_refresh = %.json<needs_surface_refresh>.Int; }
    method building_count           { return $!building_count if defined $!building_count or not defined %.json<building_count>; $!building_count = %.json<building_count>.Int; }
    method build_queue_size           { return $!build_queue_size if defined $!build_queue_size or not defined %.json<build_queue_size>; $!build_queue_size = %.json<build_queue_size>.Int; }
    method build_queue_len           { return $!build_queue_len if defined $!build_queue_len or not defined %.json<build_queue_len>; $!build_queue_len = %.json<build_queue_len>.Int; }
    method plots_available           { return $!plots_available if defined $!plots_available or not defined %.json<plots_available>; $!plots_available = %.json<plots_available>.Int; }
    method happiness           { return $!happiness if defined $!happiness or not defined %.json<happiness>; $!happiness = %.json<happiness>.Int; }
    method happiness_hour           { return $!happiness_hour if defined $!happiness_hour or not defined %.json<happiness_hour>; $!happiness_hour = %.json<happiness_hour>.Int; }
    method propaganda_boost           { return $!propaganda_boost if defined $!propaganda_boost or not defined %.json<propaganda_boost>; $!propaganda_boost = %.json<propaganda_boost>.Int; }
    method food_stored           { return $!food_stored if defined $!food_stored or not defined %.json<food_stored>; $!food_stored = %.json<food_stored>.Int; }
    method food_hour           { return $!food_hour if defined $!food_hour or not defined %.json<food_hour>; $!food_hour = %.json<food_hour>.Int; }
    method food_capacity           { return $!food_capacity if defined $!food_capacity or not defined %.json<food_capacity>; $!food_capacity = %.json<food_capacity>.Int; }
    method energy_stored           { return $!energy_stored if defined $!energy_stored or not defined %.json<energy_stored>; $!energy_stored = %.json<energy_stored>.Int; }
    method energy_hour           { return $!energy_hour if defined $!energy_hour or not defined %.json<energy_hour>; $!energy_hour = %.json<energy_hour>.Int; }
    method energy_capacity           { return $!energy_capacity if defined $!energy_capacity or not defined %.json<energy_capacity>; $!energy_capacity = %.json<energy_capacity>.Int; }
    method ore_stored           { return $!ore_stored if defined $!ore_stored or not defined %.json<ore_stored>; $!ore_stored = %.json<ore_stored>.Int; }
    method ore_hour           { return $!ore_hour if defined $!ore_hour or not defined %.json<ore_hour>; $!ore_hour = %.json<ore_hour>.Int; }
    method ore_capacity           { return $!ore_capacity if defined $!ore_capacity or not defined %.json<ore_capacity>; $!ore_capacity = %.json<ore_capacity>.Int; }
    method waste_stored           { return $!waste_stored if defined $!waste_stored or not defined %.json<waste_stored>; $!waste_stored = %.json<waste_stored>.Int; }
    method waste_hour           { return $!waste_hour if defined $!waste_hour or not defined %.json<waste_hour>; $!waste_hour = %.json<waste_hour>.Int; }
    method waste_capacity           { return $!waste_capacity if defined $!waste_capacity or not defined %.json<waste_capacity>; $!waste_capacity = %.json<waste_capacity>.Int; }
    method water_stored           { return $!water_stored if defined $!water_stored or not defined %.json<water_stored>; $!water_stored = %.json<water_stored>.Int; }
    method water_hour           { return $!water_hour if defined $!water_hour or not defined %.json<water_hour>; $!water_hour = %.json<water_hour>.Int; }
    method water_capacity           { return $!water_capacity if defined $!water_capacity or not defined %.json<water_capacity>; $!water_capacity = %.json<water_capacity>.Int; }

    method unhappy_date     { return $!unhappy_date if defined $!unhappy_date or not defined %.json<unhappy_date>; $!unhappy_date = Games::Lacuna::DateTime.from_tle(%.json<unhappy_date>); }
    method neutral_entry    { return $!neutral_entry if defined $!neutral_entry or not defined %.json<neutral_entry>; $!neutral_entry = Games::Lacuna::DateTime.from_tle(%.json<neutral_entry>); }

    ### If skip_incoming_ships is set, the following four num_* attributes 
    ### will not be sent.
    method skip_incoming_ships  { return $!skip_incoming_ships if defined $!skip_incoming_ships or not defined %.json<skip_incoming_ships>; $!skip_incoming_ships = %.json<skip_incoming_ships>.Int.Bool; }
    method num_incoming_enemy   { return $!num_incoming_enemy if defined $!num_incoming_enemy or not defined %.json<num_incoming_enemy>; $!num_incoming_enemy = %.json<num_incoming_enemy>.Int; }
    method num_incoming_ally    { return $!num_incoming_ally if defined $!num_incoming_ally or not defined %.json<num_incoming_ally>; $!num_incoming_ally = %.json<num_incoming_ally>.Int; }
    method num_incoming_own     { return $!num_incoming_own if defined $!num_incoming_own or not defined %.json<num_incoming_own>; $!num_incoming_own = %.json<num_incoming_own>.Int; }

    method empire {#{{{
        return $!empire if defined $!empire or not defined %.json<empire>;
        $!empire = Games::Lacuna::Model::Body::Empire.new( :empire_hash(%.json<empire>) );
    }#}}}
    method incoming_own_ships {#{{{
        return @!incoming_own_ships if @!incoming_own_ships.elems > 0 or not defined %.json<incoming_own_ships>;
        for %.json<incoming_own_ships>.values -> %s {
            @!incoming_own_ships.push( Games::Lacuna::Model::Body::IncomingShip.new(:ship_hash(%s)) )
        }
        @!incoming_own_ships;
    }#}}}
    method incoming_enemy_ships {#{{{
        return @!incoming_enemy_ships if @!incoming_enemy_ships.elems > 0 or not defined %.json<incoming_enemy_ships>;
        for %.json<incoming_enemy_ships> -> %s {
            @!incoming_enemy_ships.push( Games::Lacuna::Model::Body::IncomingShip.new(:ship_hash(%s)) )
        }
        @!incoming_enemy_ships;
    }#}}}
    method incoming_ally_ships {#{{{
        return @!incoming_ally_ships if @!incoming_ally_ships.elems > 0 or not defined %.json<incoming_ally_ships>;
        for %.json<incoming_ally_ships> -> %s {
            @!incoming_ally_ships.push( Games::Lacuna::Model::Body::IncomingShip.new(:ship_hash(%s)) )
        }
        @!incoming_ally_ships;
    }#}}}

    #|{
        These always return lists.  Even if you search by name of a unique 
        building (eg Planetary Command Center), you'll get back an array of 
        one element.
            my @all_bldgs   = $p.buildings();                               # Array.
            my @saws        = $p.buildings('shield against weapons');       # Seq.  Name is case insensitive.

        These always returns single Games::Lacuna::Model::Building::OwnBuilding objects.
            my $pcc         = $p.buildings( :x(0), :y(0) );
            my $whatever    = $p.buildings( :id(12345) );
    #}
    multi method buildings() {#{{{
        return @!buildings if @!buildings.elems > 0;    # no defined check on %.json<buildings>.
        my %rv = $.account.send(
            :$.endpoint_name, :method('get_buildings'),
            [$.account.session_id, $.id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %.json = %rv<result><buildings>;
 
        for %.json.kv -> $bldg_id, %hash {
            %hash<id> = $bldg_id;
            @!buildings.push( Games::Lacuna::Model::Building::OwnBuilding.new(:$.account, :json(%hash)) );   # this is what I need to end up with.
        }
        return @!buildings;
    }#}}}
    multi method buildings(Str $name --> Seq) {#{{{
        return @.buildings.grep({ $_.name.lc eqv $name.lc });
    }#}}}
    multi method buildings(Int :$x!, Int :$y! ) {#{{{
        return @.buildings.grep({ $_.x eqv $x && $_.y eqv $y })[0];
    }#}}}
    multi method buildings(Int :$id! ) {#{{{
        return @.buildings.grep({ $_.id eqv $id })[0];
    }#}}}
 

}



 # vim: syntax=perl6 fdm=marker

