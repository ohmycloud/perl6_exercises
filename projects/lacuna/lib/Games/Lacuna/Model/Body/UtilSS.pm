
class Games::Lacuna::Model::Body::UtilSS {
    has %.station_hash;
    has Int $.id;
    has Int $.x;
    has Int $.y;
    has Str $.name;
    method id   { return $!id if defined $!id or not defined %!station_hash<id>; $!id = %!station_hash<id>.Int; }
    method x    { return $!x if defined $!x or not defined %!station_hash<x>; $!x = %!station_hash<x>.Int; }
    method y    { return $!y if defined $!y or not defined %!station_hash<y>; $!y = %!station_hash<y>.Int; }
    method name { return $!name if defined $!name or not defined %!station_hash<name>; $!name = %!station_hash<name>; }
}

 # vim: syntax=perl6 fdm=marker

