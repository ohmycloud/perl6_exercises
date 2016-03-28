
use Games::Lacuna::Model;
role Games::Lacuna::Model::Building::BuildingRole does Games::Lacuna::Model {
    use Games::Lacuna::Exception;
    use Games::Lacuna::Model::Building::RepairCosts;
    use Games::Lacuna::Model::Building::PendingBuild;
    use Games::Lacuna::Model::Building::Work;
    use Games::Lacuna::Model::Building::Downgrade;
    use Games::Lacuna::Model::Building::Upgrade;

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

}


