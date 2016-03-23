
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

role Games::Lacuna::Model::Building::Working does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.seconds_remaining;
    has Games::Lacuna::DateTime $.start;
    has Games::Lacuna::DateTime $.end;
    method new (:%json_parsed)  { self.bless(:%json_parsed); }
    method seconds_remaining    { return $!seconds_remaining if defined $!seconds_remaining or not defined %.json_parsed<seconds_remaining>; $!seconds_remaining = %.json_parsed<seconds_remaining>.Int; }
    method start                { return $!start if defined $!start or not defined %.json_parsed<start>; $!start = Games::Lacuna::DateTime.from_tle(%.json_parsed<start>); }
    method end                  { return $!end if defined $!end or not defined %.json_parsed<end>; $!end = Games::Lacuna::DateTime.from_tle(%.json_parsed<end>); }
}#}}}
role Games::Lacuna::Model::Building::Cost does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.food      = 0;
    has Int $.water     = 0;
    has Int $.energy    = 0;
    has Int $.waste     = 0;
    has Int $.ore       = 0;
    has Int $.time      = 0;    # Int seconds
    method new (:%json_parsed)  { self.bless(:%json_parsed); }
    method food     { return $!food if defined $!food or not defined %.json_parsed<food>; $!food = %.json_parsed<food>.Int; }
    method water    { return $!water if defined $!water or not defined %.json_parsed<water>; $!water = %.json_parsed<water>.Int; }
    method energy   { return $!energy if defined $!energy or not defined %.json_parsed<energy>; $!energy = %.json_parsed<energy>.Int; }
    method waste    { return $!waste if defined $!waste or not defined %.json_parsed<waste>; $!waste = %.json_parsed<waste>.Int; }
    method ore      { return $!ore if defined $!ore or not defined %.json_parsed<ore>; $!ore = %.json_parsed<ore>.Int; }
    method time     { return $!time if defined $!time or not defined %.json_parsed<time>; $!time = %.json_parsed<time>.Int; }
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
    method can      { return $!can if defined $!can or not defined %.json_parsed<can>; $!can = %.json_parsed<can>.Int.Bool; }
    method because  { return $!because if defined $!because or not defined %.json_parsed<reason>; $!because = %.json_parsed<reason>; }
    method image    { return $!image if defined $!image or not defined %.json_parsed<image>; $!image = %.json_parsed<image>; }
    submethod BUILD (:%!json_parsed) { }
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
        has %.p;
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

        method food_hour        { return $!food_hour if defined $!food_hour or not defined %!p<food_hour>; $!food_hour = %!p<food_hour>.Int; }
        method food_capacity    { return $!food_capacity if defined $!food_capacity or not defined %!p<food_capacity>; $!food_capacity = %!p<food_capacity>.Int; }
        method energy_hour      { return $!energy_hour if defined $!energy_hour or not defined %!p<energy_hour>; $!energy_hour = %!p<energy_hour>.Int; }
        method energy_capacity  { return $!energy_capacity if defined $!energy_capacity or not defined %!p<energy_capacity>; $!energy_capacity = %!p<energy_capacity>.Int; }
        method ore_hour         { return $!ore_hour if defined $!ore_hour or not defined %!p<ore_hour>; $!ore_hour = %!p<ore_hour>.Int; }
        method ore_capacity     { return $!ore_capacity if defined $!ore_capacity or not defined %!p<ore_capacity>; $!ore_capacity = %!p<ore_capacity>.Int; }
        method water_hour       { return $!water_hour if defined $!water_hour or not defined %!p<water_hour>; $!water_hour = %!p<water_hour>.Int; }
        method water_capacity   { return $!water_capacity if defined $!water_capacity or not defined %!p<water_capacity>; $!water_capacity = %!p<water_capacity>.Int; }
        method waste_hour       { return $!waste_hour if defined $!waste_hour or not defined %!p<waste_hour>; $!waste_hour = %!p<waste_hour>.Int; }
        method waste_capacity   { return $!waste_capacity if defined $!waste_capacity or not defined %!p<waste_capacity>; $!waste_capacity = %!p<waste_capacity>.Int; }
        method happiness_hour   { return $!happiness_hour if defined $!happiness_hour or not defined %!p<happiness_hour>; $!happiness_hour = %!p<happiness_hour>.Int; }

        method new (:%json_parsed)  { self.bless(:%json_parsed); }
    }#}}}

    has Bool $.can;
    has Reason $.reason;
    has Games::Lacuna::Model::Building::Cost $.cost;
    has Production $.production;
    method can          { return $!can if defined $!can or not defined %.json_parsed<can>; $!can = %.json_parsed<can>.Int.Bool; }
    method reason       { return $!reason if defined $!reason or not defined %.json_parsed<reason>; $!reason = Reason.new(%.json_parsed<reason>); }
    method cost         { return $!cost if defined $!cost or not defined %.json_parsed<cost>; $!cost = Games::Lacuna::Model::Building::Cost.new(%.json_parsed<cost>); }
    method production   { return $!production if defined $!production or not defined %.json_parsed<production>; $!production = Production.new(%.json_parsed<production>); }
    submethod BUILD (:%!json_parsed) { }
}#}}}

role Games::Lacuna::Model::Building::BuildingRole does Games::Lacuna::Model {#{{{
    has %.p;                        # convenience -- just %.json_parsed<result><body>.  Handled by BUILD.
    has Int $.id;
    has Str $.name;
    has Str $.image;
    has Int $.level;
    has Int $.x;
    has Int $.y;
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

    method id               { return $!id if defined $!id or not defined %!p<id>; $!id = %!p<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!p<name>; $!name = %!p<name>; }
    method image            { return $!image if defined $!image or not defined %!p<image>; $!image = %!p<image>; }
    method level            { return $!level if defined $!level or not defined %!p<level>; $!level = %!p<level>.Int; }
    method x                { return $!x if defined $!x or not defined %!p<x>; $!x = %!p<x>.Int; }
    method y                { return $!y if defined $!y or not defined %!p<y>; $!y = %!p<y>.Int; }
    method food_hour        { return $!food_hour if defined $!food_hour or not defined %!p<food_hour>; $!food_hour = %!p<food_hour>.Int; }
    method food_capacity    { return $!food_capacity if defined $!food_capacity or not defined %!p<food_capacity>; $!food_capacity = %!p<food_capacity>.Int; }
    method energy_hour      { return $!energy_hour if defined $!energy_hour or not defined %!p<energy_hour>; $!energy_hour = %!p<energy_hour>.Int; }
    method energy_capacity  { return $!energy_capacity if defined $!energy_capacity or not defined %!p<energy_capacity>; $!energy_capacity = %!p<energy_capacity>.Int; }
    method ore_hour         { return $!ore_hour if defined $!ore_hour or not defined %!p<ore_hour>; $!ore_hour = %!p<ore_hour>.Int; }
    method ore_capacity     { return $!ore_capacity if defined $!ore_capacity or not defined %!p<ore_capacity>; $!ore_capacity = %!p<ore_capacity>.Int; }
    method water_hour       { return $!water_hour if defined $!water_hour or not defined %!p<water_hour>; $!water_hour = %!p<water_hour>.Int; }
    method water_capacity   { return $!water_capacity if defined $!water_capacity or not defined %!p<water_capacity>; $!water_capacity = %!p<water_capacity>.Int; }
    method waste_hour       { return $!waste_hour if defined $!waste_hour or not defined %!p<waste_hour>; $!waste_hour = %!p<waste_hour>.Int; }
    method waste_capacity   { return $!waste_capacity if defined $!waste_capacity or not defined %!p<waste_capacity>; $!waste_capacity = %!p<waste_capacity>.Int; }
    method happiness_hour   { return $!happiness_hour if defined $!happiness_hour or not defined %!p<happiness_hour>; $!happiness_hour = %!p<happiness_hour>.Int; }
    method efficiency       { return $!efficiency if defined $!efficiency or not defined %!p<efficiency>; $!efficiency = %!p<efficiency>.Int; }
    method repair_costs     { return $!repair_costs if defined $!repair_costs or not defined %!p<repair_costs>; $!repair_costs = Games::Lacuna::Model::Building::RepairCosts.new(%!p<repair_costs>); }
    method pending_build    { return $!pending_build if defined $!pending_build or not defined %!p<pending_build>; $!pending_build = Games::Lacuna::Model::Building::RepairCosts.new(%!p<pending_build>); }
    method work             { return $!work if defined $!work or not defined %!p<work>; $!work = Games::Lacuna::Model::Building::RepairCosts.new(%!p<work>); }
    method downgrade        { return $!downgrade if defined $!downgrade or not defined %!p<downgrade>; $!downgrade = Games::Lacuna::Model::Building::RepairCosts.new(%!p<downgrade>); }
    method upgrade          { return $!upgrade if defined $!upgrade or not defined %!p<upgrade>; $!upgrade = Games::Lacuna::Model::Building::RepairCosts.new(%!p<upgrade>); }

}#}}}

class Games::Lacuna::Model::Building::OwnBuilding does Games::Lacuna::Model::Building::BuildingRole {#{{{
    submethod BUILD (:$!account, :%!json_parsed) {
        %!p = %!json_parsed
    }

}#}}}


#|{
    Factory class.

    Depending upon arguments, returns one of:
        Games::Lacuna::Model::Building  WHAT??????

#}
class Games::Lacuna::Model::Building {

    multi method new (%data, :$account!) {#{{{
        return Games::Lacuna::Model::Building::OwnBuilding.new( :$account, :json_parsed(%data) );
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

