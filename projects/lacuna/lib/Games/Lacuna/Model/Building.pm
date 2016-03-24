
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

role Games::Lacuna::Model::Building::Working does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.seconds_remaining;
    has Games::Lacuna::DateTime $.start;
    has Games::Lacuna::DateTime $.end;
    method new (:%json)  { self.bless(:%json); }
    method seconds_remaining    { return $!seconds_remaining if defined $!seconds_remaining or not defined %.json<seconds_remaining>; $!seconds_remaining = %.json<seconds_remaining>.Int; }
    method start                { return $!start if defined $!start or not defined %.json<start>; $!start = Games::Lacuna::DateTime.from_tle(%.json<start>); }
    method end                  { return $!end if defined $!end or not defined %.json<end>; $!end = Games::Lacuna::DateTime.from_tle(%.json<end>); }
}#}}}
role Games::Lacuna::Model::Building::Cost does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.food      = 0;
    has Int $.water     = 0;
    has Int $.energy    = 0;
    has Int $.waste     = 0;
    has Int $.ore       = 0;
    has Int $.time      = 0;    # Int seconds
    method new (:%json)  { self.bless(:%json); }
    method food     { return $!food if defined $!food or not defined %.json<food>; $!food = %.json<food>.Int; }
    method water    { return $!water if defined $!water or not defined %.json<water>; $!water = %.json<water>.Int; }
    method energy   { return $!energy if defined $!energy or not defined %.json<energy>; $!energy = %.json<energy>.Int; }
    method waste    { return $!waste if defined $!waste or not defined %.json<waste>; $!waste = %.json<waste>.Int; }
    method ore      { return $!ore if defined $!ore or not defined %.json<ore>; $!ore = %.json<ore>.Int; }
    method time     { return $!time if defined $!time or not defined %.json<time>; $!time = %.json<time>.Int; }
}#}}}
class Games::Lacuna::Model::Building::PendingBuild does Games::Lacuna::Model::Building::Working { }
class Games::Lacuna::Model::Building::Work does Games::Lacuna::Model::Building::Working { }
class Games::Lacuna::Model::Building::RepairCosts does Games::Lacuna::Model::Building::Cost { }
class Games::Lacuna::Model::Building::Downgrade does Games::Lacuna::Model::NonCommModel {#{{{
    has Bool $.can;
    has Str $.because; 
    has Str $.image;
    ### The server uses the word 'reason' instead of 'because'.  But Upgrade 
    ### also has a 'reason' attribute, and it's a class, not a string, where 
    ### here we only get a string.  So I'm changing the name to avoid 
    ### confusion.  Hopefully.
    method can      { return $!can if defined $!can or not defined %.json<can>; $!can = %.json<can>.Int.Bool; }
    method because  { return $!because if defined $!because or not defined %.json<reason>; $!because = %.json<reason>; }
    method image    { return $!image if defined $!image or not defined %.json<image>; $!image = %.json<image>; }
    submethod BUILD (:%!json) { }
}#}}}
class Games::Lacuna::Model::Building::Upgrade does Games::Lacuna::Model::NonCommModel {#{{{
    class Reason {#{{{
        has Int $.code;
        has Str $.message;
        has Str $.data;
        method new(@data) {
            self.BUILD( :code(@data[0]), :message(@data[1]), :data(@data[2]) );
        }
    }#}}}
    class Production {#{{{
        has %.json;
        has Int $.food_hour;
        has Int $.food_capacity;
        has Int $.energy_hour;
        has Int $.energy_capacity;
        has Int $.ore_hour;
        has Int $.ore_capacity;
        has Int $.water_hour;
        has Int $.water_capacity;
        has Int $.waste_hour;
        has Int $.waste_capacity;
        has Int $.happiness_hour;

        method food_hour        { return $!food_hour if defined $!food_hour or not defined %!json<food_hour>; $!food_hour = %!json<food_hour>.Int; }
        method food_capacity    { return $!food_capacity if defined $!food_capacity or not defined %!json<food_capacity>; $!food_capacity = %!json<food_capacity>.Int; }
        method energy_hour      { return $!energy_hour if defined $!energy_hour or not defined %!json<energy_hour>; $!energy_hour = %!json<energy_hour>.Int; }
        method energy_capacity  { return $!energy_capacity if defined $!energy_capacity or not defined %!json<energy_capacity>; $!energy_capacity = %!json<energy_capacity>.Int; }
        method ore_hour         { return $!ore_hour if defined $!ore_hour or not defined %!json<ore_hour>; $!ore_hour = %!json<ore_hour>.Int; }
        method ore_capacity     { return $!ore_capacity if defined $!ore_capacity or not defined %!json<ore_capacity>; $!ore_capacity = %!json<ore_capacity>.Int; }
        method water_hour       { return $!water_hour if defined $!water_hour or not defined %!json<water_hour>; $!water_hour = %!json<water_hour>.Int; }
        method water_capacity   { return $!water_capacity if defined $!water_capacity or not defined %!json<water_capacity>; $!water_capacity = %!json<water_capacity>.Int; }
        method waste_hour       { return $!waste_hour if defined $!waste_hour or not defined %!json<waste_hour>; $!waste_hour = %!json<waste_hour>.Int; }
        method waste_capacity   { return $!waste_capacity if defined $!waste_capacity or not defined %!json<waste_capacity>; $!waste_capacity = %!json<waste_capacity>.Int; }
        method happiness_hour   { return $!happiness_hour if defined $!happiness_hour or not defined %!json<happiness_hour>; $!happiness_hour = %!json<happiness_hour>.Int; }

        method new (:%json)  { self.bless(:%json); }
    }#}}}

    has Bool $.can;
    has Reason $.reason;
    has Games::Lacuna::Model::Building::Cost $.cost;
    has Production $.production;
    method can          { return $!can if defined $!can or not defined %.json<can>; $!can = %.json<can>.Int.Bool; }
    method reason       { return $!reason if defined $!reason or not defined %.json<reason>; $!reason = Reason.new(%.json<reason>); }
    method cost         { return $!cost if defined $!cost or not defined %.json<cost>; $!cost = Games::Lacuna::Model::Building::Cost.new(%.json<cost>); }
    method production   { return $!production if defined $!production or not defined %.json<production>; $!production = Production.new(%.json<production>); }
    submethod BUILD (:%!json) { }
}#}}}
role Games::Lacuna::Model::Building::BuildingRole does Games::Lacuna::Model {#{{{
    has Int $.id;
    has Str $.name;
    has Str $.image;
    has Int $.level;
    has Int $.x;
    has Int $.y;
    has Str $.url;          # eg "/apple"
    has Str $.type;         # derived from $.url; removes the slash.  eg "apple"
    has Int $.food_hour;
    has Int $.food_capacity;
    has Int $.energy_hour;
    has Int $.energy_capacity;
    has Int $.ore_hour;
    has Int $.ore_capacity;
    has Int $.water_hour;
    has Int $.water_capacity;
    has Int $.waste_hour;
    has Int $.waste_capacity;
    has Int $.happiness_hour;
    has Int $.efficiency;

    has Games::Lacuna::Model::Building::RepairCosts $.repair_costs;
    has Games::Lacuna::Model::Building::PendingBuild $.pending_build;
    has Games::Lacuna::Model::Building::Work $.work;
    has Games::Lacuna::Model::Building::Downgrade $.downgrade;
    has Games::Lacuna::Model::Building::Upgrade $.upgrade;

    method id               { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method name             { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
    method image            { return $!image if defined $!image or not defined %.json<image>; $!image = %.json<image>; }
    method level            { return $!level if defined $!level or not defined %.json<level>; $!level = %.json<level>.Int; }
    method x                { return $!x if defined $!x or not defined %.json<x>; $!x = %.json<x>.Int; }
    method y                { return $!y if defined $!y or not defined %.json<y>; $!y = %.json<y>.Int; }
    method url              { return $!url if defined $!url or not defined %.json<url>; $!url = %.json<url>; }
    method food_hour        { return $!food_hour if defined $!food_hour or not defined %.json<food_hour>; $!food_hour = %.json<food_hour>.Int; }
    method food_capacity    { return $!food_capacity if defined $!food_capacity or not defined %.json<food_capacity>; $!food_capacity = %.json<food_capacity>.Int; }
    method energy_hour      { return $!energy_hour if defined $!energy_hour or not defined %.json<energy_hour>; $!energy_hour = %.json<energy_hour>.Int; }
    method energy_capacity  { return $!energy_capacity if defined $!energy_capacity or not defined %.json<energy_capacity>; $!energy_capacity = %.json<energy_capacity>.Int; }
    method ore_hour         { return $!ore_hour if defined $!ore_hour or not defined %.json<ore_hour>; $!ore_hour = %.json<ore_hour>.Int; }
    method ore_capacity     { return $!ore_capacity if defined $!ore_capacity or not defined %.json<ore_capacity>; $!ore_capacity = %.json<ore_capacity>.Int; }
    method water_hour       { return $!water_hour if defined $!water_hour or not defined %.json<water_hour>; $!water_hour = %.json<water_hour>.Int; }
    method water_capacity   { return $!water_capacity if defined $!water_capacity or not defined %.json<water_capacity>; $!water_capacity = %.json<water_capacity>.Int; }
    method waste_hour       { return $!waste_hour if defined $!waste_hour or not defined %.json<waste_hour>; $!waste_hour = %.json<waste_hour>.Int; }
    method waste_capacity   { return $!waste_capacity if defined $!waste_capacity or not defined %.json<waste_capacity>; $!waste_capacity = %.json<waste_capacity>.Int; }
    method happiness_hour   { return $!happiness_hour if defined $!happiness_hour or not defined %.json<happiness_hour>; $!happiness_hour = %.json<happiness_hour>.Int; }
    method efficiency       { return $!efficiency if defined $!efficiency or not defined %.json<efficiency>; $!efficiency = %.json<efficiency>.Int; }
    method repair_costs     { return $!repair_costs if defined $!repair_costs or not defined %.json<repair_costs>; $!repair_costs = Games::Lacuna::Model::Building::RepairCosts.new(%.json<repair_costs>); }
    method pending_build    { return $!pending_build if defined $!pending_build or not defined %.json<pending_build>; $!pending_build = Games::Lacuna::Model::Building::RepairCosts.new(%.json<pending_build>); }
    method work             { return $!work if defined $!work or not defined %.json<work>; $!work = Games::Lacuna::Model::Building::RepairCosts.new(%.json<work>); }
    method downgrade        { return $!downgrade if defined $!downgrade or not defined %.json<downgrade>; $!downgrade = Games::Lacuna::Model::Building::RepairCosts.new(%.json<downgrade>); }
    method upgrade          { return $!upgrade if defined $!upgrade or not defined %.json<upgrade>; $!upgrade = Games::Lacuna::Model::Building::RepairCosts.new(%.json<upgrade>); }

    method type             { return $!type if defined $!type; $!type = $.url.substr(1); }

}#}}}



class Games::Lacuna::Model::Building::OwnBuilding does Games::Lacuna::Model::Building::BuildingRole {#{{{
}#}}}



#|{
    Factory class.

    Depending upon arguments, returns one of:
        Games::Lacuna::Model::Building::OwnBuilding

#}
class Games::Lacuna::Model::Building {

    multi method new (%data, :$account!) {#{{{
        return Games::Lacuna::Model::Building::OwnBuilding.new( :$account, :json(%data) );
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

