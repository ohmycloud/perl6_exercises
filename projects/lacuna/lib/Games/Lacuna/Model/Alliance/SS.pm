
use Games::Lacuna::Model::NonCommModel;

class Games::Lacuna::Model::Alliance::SS does Games::Lacuna::Model::NonCommModel {
    has Int $.id;
    has Str $.name;
    has Int $.x;
    has Int $.y;

    submethod BUILD (:%!json!) { }
    method id   { return $!id if defined $!id or not defined %!json<id>; $!id = %!json<id>.Int; }
    method name { return $!name if defined $!name or not defined %!json<name>; $!name = %!json<name>; }
    method x   { return $!x if defined $!x or not defined %!json<x>; $!x = %!json<x>.Int; }
    method y   { return $!y if defined $!y or not defined %!json<y>; $!y = %!json<y>.Int; }
}

 # vim: syntax=perl6 fdm=marker

