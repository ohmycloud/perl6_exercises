
### CHECK
### I've set up Body as a factory which is able to return ForeignBody or 
### ForeignSS classes - those classes are little subsets of Body or SS that 
### get included in other classes (like a Profile that returns 
### known_colonies).
###
### In the same way, I should set up Empire and Ship factories that can also 
### return little clumps of code.  Once that's done, the Empire and 
### IncomingShip classes in here should be replaced by those factories.
class Games::Lacuna::Model::Body::Empire {
    has %.empire_hash;
    has Int $.id;
    has Str $.name;
    has Str $.alignment;
    has Bool $.is_isolationist;

    method id               { return $!id if defined $!id or not defined %!empire_hash<id>; $!id = %!empire_hash<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!empire_hash<name>; $!name = %!empire_hash<name>; }
    method alignment        { return $!alignment if defined $!alignment or not defined %!empire_hash<alignment>; $!alignment = %!empire_hash<alignment>; }
    method is_isolationist  { return $!is_isolationist if defined $!is_isolationist or not defined %!empire_hash<is_isolationist>; $!is_isolationist = %!empire_hash<is_isolationist>.Int.Bool; }
}

 # vim: syntax=perl6 fdm=marker

