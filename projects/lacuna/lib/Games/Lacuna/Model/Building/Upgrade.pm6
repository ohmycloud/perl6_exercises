
use Games::Lacuna::Model::NonCommModel;

class Games::Lacuna::Model::Building::Upgrade does Games::Lacuna::Model::NonCommModel {
    use Games::Lacuna::Model::Building::Cost;

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
}

