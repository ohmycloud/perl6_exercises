
use Games::Lacuna::Model::NonCommModel;

class Games::Lacuna::Model::Alliance::Member does Games::Lacuna::Model::NonCommModel {
    has Int $.id;
    has Str $.name;

    submethod BUILD (:%!json!) { }
    method id   { return $!id if defined $!id or not defined %!json<id>; $!id = %!json<id>.Int; }
    method name { return $!name if defined $!name or not defined %!json<name>; $!name = %!json<name>; }
}

 # vim: syntax=perl6 fdm=marker

