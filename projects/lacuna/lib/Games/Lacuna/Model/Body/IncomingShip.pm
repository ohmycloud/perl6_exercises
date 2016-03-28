
use Games::Lacuna::DateTime;

### CHECK
### I've set up Body as a factory which is able to return ForeignBody or 
### ForeignSS classes - those classes are little subsets of Body or SS that 
### get included in other classes (like a Profile that returns 
### known_colonies).
###
### In the same way, I should set up Empire and Ship factories that can also 
### return little clumps of code.  Once that's done, the Empire and 
### IncomingShip classes in here should be replaced by those factories.
class Games::Lacuna::Model::Body::IncomingShip {
    has %.ship_hash;
    has Int $.id;
    has Games::Lacuna::DateTime $.date_arrives;
    has Bool $.is_own;
    has Bool $.is_ally;

    method id           { return $!id if defined $!id or not defined %!ship_hash<id>; $!id = %!ship_hash<id>.Int; }
    method date_arrives { return $!date_arrives if defined $!date_arrives or not defined %!ship_hash<date_arrives>; $!date_arrives = Games::Lacuna::DateTime.from_tle(%!ship_hash<date_arrives>); }
    method is_own       { return $!is_own if defined $!is_own or not defined %!ship_hash<is_own>; $!is_own = %!ship_hash<is_own>.Int.Bool; }
    method is_ally      { return $!is_ally if defined $!is_ally or not defined %!ship_hash<is_ally>; $!is_ally = %!ship_hash<is_ally>.Int.Bool; }
}

 # vim: syntax=perl6 fdm=marker

