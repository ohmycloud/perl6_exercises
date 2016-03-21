
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;
use Games::Lacuna::Model::Alliance;

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
class Games::Lacuna::Model::Body::Empire does Games::Lacuna::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;
    has Str $.alignment;
    has Bool $.is_isolationist;

    submethod BUILD (:%!json_parsed) { }
    method id               { return $!id if defined $!id or not defined %!json_parsed<id>; $!id = %!json_parsed<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!json_parsed<name>; $!name = %!json_parsed<name>; }
    method alignment        { return $!alignment if defined $!alignment or not defined %!json_parsed<alignment>; $!alignment = %!json_parsed<alignment>; }
    method is_isolationist  { return $!is_isolationist if defined $!is_isolationist or not defined %!json_parsed<is_isolationist>; $!is_isolationist = %!json_parsed<is_isolationist>.Int.Bool; }
}#}}}
class Games::Lacuna::Model::Body::IncomingShip does Games::Lacuna::NonCommModel {#{{{
    has Int $.id;
    has Games::Lacuna::DateTime $.date_arrives;
    has Bool $.is_own;
    has Bool $.is_ally;

    submethod BUILD (:%!json_parsed) { }
    method id           { return $!id if defined $!id or not defined %!json_parsed<id>; $!id = %!json_parsed<id>.Int; }
    method date_arrives { return $!date_arrives if defined $!date_arrives or not defined %.json_parsed<date_arrives>; $!date_arrives = Games::Lacuna::DateTime.from_tle(%.json_parsed<date_arrives>); }
    method is_own       { return $!is_own if defined $!is_own or not defined %!json_parsed<is_own>; $!is_own = %!json_parsed<is_own>.Int.Bool; }
    method is_ally      { return $!is_ally if defined $!is_ally or not defined %!json_parsed<is_ally>; $!is_ally = %!json_parsed<is_ally>.Int.Bool; }
}#}}}

### Used by BodyRole.
class Games::Lacuna::Model::Body::UtilSS {#{{{
    has %.p;
    has Int $.id;
    has Int $.x;
    has Int $.y;
    has Str $.name;
    submethod BUILD (:%station_hash) {
        %!p = %station_hash;
    }
    method id   { return $!id if defined $!id or not defined %!p<id>; $!id = %!p<id>.Int; }
    method x    { return $!x if defined $!x or not defined %!p<x>; $!x = %!p<x>.Int; }
    method y    { return $!y if defined $!y or not defined %!p<y>; $!y = %!p<y>.Int; }
    method name { return $!name if defined $!name or not defined %!p<name>; $!name = %!p<name>; }
}#}}}

### Used by SSRole.
class Games::Lacuna::Model::Body::UtilInfluence {#{{{
    has %.p;
    has Int $.total;
    has Int $.spent;
    submethod BUILD (:%influence) { %!p = %influence; }
    method total   { return $!total if defined $!total or not defined %!p<total>; $!total = %!p<total>.Int; }
    method spent   { return $!spent if defined $!spent or not defined %!p<spent>; $!spent = %!p<spent>.Int; }
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

    has Int %.ore;
    has Games::Lacuna::Model::Body::UtilSS $.station;          # Only set if the body is under SS control

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
    method ore          { return %!ore if %!ore.keys.elems > 0 or not defined %!p<ore>; %!ore = %!p<ore>; }


    ### I wanted to do this:
        #method station { return $!station if defined $!station or not defined %!p<station>; $!station = Games::Lacuna::Model::Body.new(:station_hash(%!p<station>)); }
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
    method station { return $!station if defined $!station or not defined %!p<station>; $!station = Games::Lacuna::Model::Body::UtilSS.new(:station_hash(%!p<station>)); }
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

    method empire {#{{{
        return $!empire if defined $!empire or not defined %.p<empire>;
        $!empire = Games::Lacuna::Model::Body::Empire.new( :json_parsed(%.p<empire>) );
    }#}}}
    method incoming_own_ships {#{{{
        return @!incoming_own_ships if @!incoming_own_ships.elems > 0 or not defined %.p<incoming_own_ships>;
        for %.p<incoming_own_ships>.values -> %s {
            @!incoming_own_ships.push( Games::Lacuna::Model::Body::IncomingShip.new(:json_parsed(%s)) )
        }
        @!incoming_own_ships;
    }#}}}
    method incoming_enemy_ships {#{{{
        return @!incoming_enemy_ships if @!incoming_enemy_ships.elems > 0 or not defined %.p<incoming_enemy_ships>;
        for %.p<incoming_enemy_ships> -> %s {
            @!incoming_enemy_ships.push( Games::Lacuna::Model::Body::IncomingShip.new(:json_parsed(%s)) )
        }
        @!incoming_enemy_ships;
    }#}}}
    method incoming_ally_ships {#{{{
        return @!incoming_ally_ships if @!incoming_ally_ships.elems > 0 or not defined %.p<incoming_ally_ships>;
        for %.p<incoming_ally_ships> -> %s {
            @!incoming_ally_ships.push( Games::Lacuna::Model::Body::IncomingShip.new(:json_parsed(%s)) )
        }
        @!incoming_ally_ships;
    }#}}}
 
}#}}}
role Games::Lacuna::Model::Body::ForeignBodyRole does Games::Lacuna::NonCommModel does Games::Lacuna::Model::Body::BodyRole {#{{{
}#}}}

#|{
    Any class that implements this role must also implement BodyRole.
#}
role Games::Lacuna::Model::Body::SSRole {#{{{
    has Games::Lacuna::Model::Alliance::PartialAlliance $.alliance;
    has Games::Lacuna::Model::Body::UtilInfluence $.influence;

    method alliance { return $!alliance if defined $!alliance or not defined %.p<alliance>; $!alliance = Games::Lacuna::Model::Alliance.new(:json_parsed(%.p<alliance>)); }
    method influence { return $!influence if defined $!influence or not defined %.p<influence>; $!influence = Games::Lacuna::Model::Body::UtilInfluence.new(:influence(%.p<influence>)); }
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
        try { %!p = %!json_parsed<result><body> };
    }

}#}}}
class Games::Lacuna::Model::Body::ForeignPlanet does Games::Lacuna::Model::Body::ForeignBodyRole {#{{{
    submethod BUILD (:%planet_hash) {
        %!json_parsed   = %planet_hash;
        %!p             = %planet_hash;
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
        try { %!p = %!json_parsed<result><body> };
    }
}#}}}
class Games::Lacuna::Model::Body::ForeignSS does Games::Lacuna::Model::Body::SSRole does Games::Lacuna::Model::Body::ForeignBodyRole {#{{{
    submethod BUILD (:%station_hash) {
        %!json_parsed   = %station_hash;
        %!p             = %station_hash;
    }
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
class Games::Lacuna::Model::Body {#{{{
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

}#}}}



 # vim: syntax=perl6 fdm=marker

