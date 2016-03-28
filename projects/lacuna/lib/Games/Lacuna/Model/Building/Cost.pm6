
use Games::Lacuna::Model::NonCommModel;

role Games::Lacuna::Model::Building::Cost does Games::Lacuna::Model::NonCommModel {
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
}

