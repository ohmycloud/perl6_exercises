
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;
use Games::Lacuna::Model::Alliance;
use Games::Lacuna::Model::Building;

### Utility classes.  These are part of some of the Body responses.
###
### CHECK
### I've set up Body as a factory which is able to return ForeignBody or 
### ForeignSS classes - those classes are little subsets of Body or SS that 
### get included in other classes (like a Profile that returns 
### known_colonies).
###
### In the same way, I should set up Empire and Ship factories that can also 
### return little clumps of code.  Once that's done, the Empire and 
### IncomingShip classes in here should be replaced by those factories.
class Games::Lacuna::Model::Body::Empire {#{{{
    has %.empire_hash;
    has Int $.id;
    has Str $.name;
    has Str $.alignment;
    has Bool $.is_isolationist;

    method id               { return $!id if defined $!id or not defined %!empire_hash<id>; $!id = %!empire_hash<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!empire_hash<name>; $!name = %!empire_hash<name>; }
    method alignment        { return $!alignment if defined $!alignment or not defined %!empire_hash<alignment>; $!alignment = %!empire_hash<alignment>; }
    method is_isolationist  { return $!is_isolationist if defined $!is_isolationist or not defined %!empire_hash<is_isolationist>; $!is_isolationist = %!empire_hash<is_isolationist>.Int.Bool; }
}#}}}
class Games::Lacuna::Model::Body::IncomingShip {#{{{
    has %.ship_hash;
    has Int $.id;
    has Games::Lacuna::DateTime $.date_arrives;
    has Bool $.is_own;
    has Bool $.is_ally;

    method id           { return $!id if defined $!id or not defined %!ship_hash<id>; $!id = %!ship_hash<id>.Int; }
    method date_arrives { return $!date_arrives if defined $!date_arrives or not defined %!ship_hash<date_arrives>; $!date_arrives = Games::Lacuna::DateTime.from_tle(%!ship_hash<date_arrives>); }
    method is_own       { return $!is_own if defined $!is_own or not defined %!ship_hash<is_own>; $!is_own = %!ship_hash<is_own>.Int.Bool; }
    method is_ally      { return $!is_ally if defined $!is_ally or not defined %!ship_hash<is_ally>; $!is_ally = %!ship_hash<is_ally>.Int.Bool; }
}#}}}

### Used by BodyRole and SSRole.
class Games::Lacuna::Model::Body::UtilSS {#{{{
    has %.station_hash;
    has Int $.id;
    has Int $.x;
    has Int $.y;
    has Str $.name;
    method id   { return $!id if defined $!id or not defined %!station_hash<id>; $!id = %!station_hash<id>.Int; }
    method x    { return $!x if defined $!x or not defined %!station_hash<x>; $!x = %!station_hash<x>.Int; }
    method y    { return $!y if defined $!y or not defined %!station_hash<y>; $!y = %!station_hash<y>.Int; }
    method name { return $!name if defined $!name or not defined %!station_hash<name>; $!name = %!station_hash<name>; }
}#}}}
class Games::Lacuna::Model::Body::UtilInfluence {#{{{
    has %.influence;
    has Int $.total;
    has Int $.spent;
    method total   { return $!total if defined $!total or not defined %!influence<total>; $!total = %!influence<total>.Int; }
    method spent   { return $!spent if defined $!spent or not defined %!influence<spent>; $!spent = %!influence<spent>.Int; }
}#}}}

role Games::Lacuna::Model::Body::BodyRole {#{{{
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

    has Int %.ore;
    has Games::Lacuna::Model::Body::UtilSS $.station;          # Only set if the body is under SS control

    method id           { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method x            { return $!x if defined $!x or not defined %.json<x>; $!x = %.json<x>.Int; }
    method y            { return $!y if defined $!y or not defined %.json<y>; $!y = %.json<y>.Int; }
    method star_id      { return $!star_id if defined $!star_id or not defined %.json<star_id>; $!star_id = %.json<star_id>.Int; }
    method orbit        { return $!orbit if defined $!orbit or not defined %.json<orbit>; $!orbit = %.json<orbit>.Int; }
    method size         { return $!size if defined $!size or not defined %.json<size>; $!size = %.json<size>.Int; }
    method water        { return $!water if defined $!water or not defined %.json<water>; $!water = %.json<water>.Int; }
    method star_name    { return $!star_name if defined $!star_name or not defined %.json<star_name>; $!star_name = %.json<star_name>; }
    method type         { return $!type if defined $!type or not defined %.json<type>; $!type = %.json<type>; }
    method name         { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
    method image        { return $!image if defined $!image or not defined %.json<image>; $!image = %.json<image>; }
    method ore          { return %!ore if %!ore.keys.elems > 0 or not defined %.json<ore>; %!ore = %.json<ore>; }


    ### I wanted to do this:
        #method station { return $!station if defined $!station or not defined %.json<station>; $!station = Games::Lacuna::Model::Body.new(:station_hash(%.json<station>)); }
    ###
    ### But at this point, we're in a chicken-and-egg situation, and p6 won't 
    ### let me do that.  The error given is "You cannot create an instance of 
    ### this type".
    ###
    ### The problem looks like it has to do with lexical ordering, and just 
    ### moving roles and classes around in here might work (I haven't looked 
    ### into it enough to see if it's possible), but would be really fragile.
    ###
    ### So instead, I created the UtilSS class which doesn't depend on 
    ### anything.  I'd have preferred not to have to do that, but am not 
    ### seeing any other solutions, and this does work just fine.
    method station { return $!station if defined $!station or not defined %.json<station>; $!station = Games::Lacuna::Model::Body::UtilSS.new(:station_hash(%.json<station>)); }
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

    has Games::Lacuna::Model::Body::Empire $.empire;
    has Games::Lacuna::Model::Body::IncomingShip @.incoming_enemy_ships;
    has Games::Lacuna::Model::Body::IncomingShip @.incoming_ally_ships;
    has Games::Lacuna::Model::Body::IncomingShip @.incoming_own_ships;

    has Games::Lacuna::Model::Building::OwnBuilding @.buildings;

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
    }
    multi method buildings(--> Array) {#{{{
        return @!buildings if @!buildings.elems > 0;    # no defined check on %.json<buildings>.
        my %rv = $.account.send(
            :$.endpoint_name, :method('get_buildings'),
            [$.account.session_id, $.id]
        );
        %.json = %rv<result><buildings>;
 
        for %.json.kv -> $bldg_id, %hash {
            %hash<id> = $bldg_id;
            @!buildings.push( Games::Lacuna::Model::Building.new(:$.account, %hash) );
        }
        return @!buildings;
    }#}}}
    multi method buildings(Str $name --> Seq) {#{{{
        return @.buildings.grep({ $_.name.lc eqv $name.lc });
    }#}}}
    multi method buildings(Int :$x!, Int :$y! --> Games::Lacuna::Model::Building::OwnBuilding) {#{{{
        return @.buildings.grep({ $_.x eqv $x && $_.y eqv $y })[0];
    }#}}}
    multi method buildings(Int :$id! --> Games::Lacuna::Model::Building::OwnBuilding) {#{{{
        return @.buildings.grep({ $_.id eqv $id })[0];
    }#}}}
 
}#}}}
role Games::Lacuna::Model::Body::ForeignBodyRole does Games::Lacuna::Model::NonCommModel does Games::Lacuna::Model::Body::BodyRole {#{{{
}#}}}

#|{
    Any class that implements this role must also implement BodyRole.
#}
role Games::Lacuna::Model::Body::SSRole {#{{{
    has Games::Lacuna::Model::Alliance::PartialAlliance $.alliance;
    has Games::Lacuna::Model::Body::UtilInfluence $.influence;

    method alliance { return $!alliance if defined $!alliance or not defined %.json<alliance>; $!alliance = Games::Lacuna::Model::Alliance.new(:json(%.json<alliance>)); }
    method influence { return $!influence if defined $!influence or not defined %.json<influence>; $!influence = Games::Lacuna::Model::Body::UtilInfluence.new(:influence(%.json<influence>)); }
}#}}}

class Games::Lacuna::Model::Body::OwnPlanet does Games::Lacuna::Model::Body::OwnBodyRole {#{{{
    submethod BUILD (:$account, :$body_id) {
        $!account       = $account;
        $!endpoint_name = 'body';
        my %rv          = $!account.send(
            :$!endpoint_name, :method('get_status'),
            [$!account.session_id, $body_id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><body>;
    }

}#}}}
class Games::Lacuna::Model::Body::ForeignPlanet does Games::Lacuna::Model::Body::ForeignBodyRole {#{{{
    submethod BUILD (:%planet_hash) {
        %!json   = %planet_hash;
    }
}#}}}

class Games::Lacuna::Model::Body::OwnSS does Games::Lacuna::Model::Body::SSRole does Games::Lacuna::Model::Body::OwnBodyRole {#{{{
    submethod BUILD (:$account, :$body_id) {
        $!account       = $account;
        $!endpoint_name = 'body';
        my %rv          = $!account.send(
            :$!endpoint_name, :method('get_status'),
            ($!account.session_id, $body_id)
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><body>;
    }
}#}}}
class Games::Lacuna::Model::Body::ForeignSS does Games::Lacuna::Model::Body::SSRole does Games::Lacuna::Model::Body::ForeignBodyRole {#{{{
    submethod BUILD (:%station_hash) { %!json = %station_hash; }
}#}}}


#|{
    Factory class.

    Depending upon arguments, returns one of:
        Games::Lacuna::Model::Body::OwnPlanet
        Games::Lacuna::Model::Body::OwnSS
        Games::Lacuna::Model::Body::ForeignPlanet
        Games::Lacuna::Model::Body::ForeignSS

    The Own* classes refer to a body owned by the user or his alliance, and 
    implement the various Body methods.
        https://us1.lacunaexpanse.com/api/Body.html

    The Foreign* classes generally get handed back as part of another 
    response.  eg a user's PublicProfile contains a list of known_colonies, 
    which will become a list of ForiegnPlanet objects.  These are mostly just 
    collections of data.  You can't call methods on a Body that's not yours.

    What Body attributes actually get set in the Foriegn* classes vary, but 
    id, name, x, and y are pretty common.

    Examples:
            my $own_planet = Games::Lacuna::Model::Body.new( :$account, :body_name("Earth") );      # name of a planet
            my $own_planet = Games::Lacuna::Model::Body.new( :$account, :body_id(12345) );          # ID of a planet

        "own station" doesn't need to be a station your account personally 
        owns.  It can be controlled by any member of your alliance.
            my $own_station = Games::Lacuna::Model::Body.new( :$account, :body_name("ISS") );       # name of a station
            my $own_station = Games::Lacuna::Model::Body.new( :$account, :body_id(23456) );         # ID of a station

        When another response hands you back a small hash of details about a 
        planet or station:
            my %p = %resp<keys><to><planet_details>;
            my %s = %resp<keys><to><station_details>;
            my $for_planet  = Games::Lacuna::Model::Body.new( :planet_hash(%p) );
            my $for_station = Games::Lacuna::Model::Body.new( :station_hash(%s) );
#}
class Games::Lacuna::Model::Body {

    multi method new (:$account!, :$body_name!) {#{{{
        return Games::Lacuna::Model::Body::OwnPlanet.new(:$account, :body_id($account.mycolonies<names>{$body_name}))    if $account.mycolonies<names>{$body_name};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :body_id($account.mystations<names>{$body_name}))    if $account.mystations<names>{$body_name};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :body_id($account.ourstations<names>{$body_name}))   if $account.ourstations<names>{$body_name};
        die "You can only access a body by name if you own it.";
    }#}}}
    multi method new (:$account!, :$body_id!) {#{{{
        return Games::Lacuna::Model::Body::OwnPlanet.new(:$account, :$body_id)  if $account.mycolonies<ids>{$body_id};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :$body_id)  if $account.mystations<ids>{$body_id};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :$body_id)  if $account.ourstations<ids>{$body_id};
        die "You can only access a body by ID if you own it.";
    }#}}}
    multi method new (:%planet_hash!) {#{{{
        return Games::Lacuna::Model::Body::ForeignPlanet.new(:%planet_hash);
    }#}}}
    multi method new (:%station_hash!) {#{{{
        return Games::Lacuna::Model::Body::ForeignSS.new(:%station_hash);
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

