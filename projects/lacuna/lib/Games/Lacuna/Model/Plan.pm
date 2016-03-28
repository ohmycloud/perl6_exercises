
use Games::Lacuna::Model::NonCommModel;

class Games::Lacuna::Model::Plan does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.quantity;
    has Str $.name;
    has Int $.level;
    has Int $.extra_build_level;
    method quantity             { return $!quantity if defined $!quantity or not defined %.json<quantity>; $!quantity = %.json<quantity>.Int; }
    method name                 { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
    method level                { return $!level if defined $!level or not defined %.json<level>; $!level = %.json<level>.Int; }
    method extra_build_level    { return $!extra_build_level if defined $!extra_build_level or not defined %.json<extra_build_level>; $!extra_build_level = %.json<extra_build_level>.Int; }
}#}}}



 # vim: syntax=perl6 fdm=marker

