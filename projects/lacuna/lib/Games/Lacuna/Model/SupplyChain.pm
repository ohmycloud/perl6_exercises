
use Games::Lacuna::Model;

### CHECK
###
### Again, I cannot use GL::Body into this module or I end up in an infinite 
### loop, since GL::Body is use'ing this module.  But without use'ing 
### GL::Body, I can't call its constructor.
###
### GL::Body should already be in INC or whatever the p6 equiv is - the fact 
### that I can't access it seems fucky.
###
### In the meantime, here's a util class.
class Games::Lacuna::Model::SupplyChain::FromBody {#{{{
    has %.planet_hash;
    has Int $.id;
    has Str $.name;
    has Int $.x;
    has Int $.y;
    method id   { return $!id if defined $!id or not defined %!planet_hash<id>; $!id = %!planet_hash<id>.Int; }
    method name { return $!name if defined $!name or not defined %!planet_hash<name>; $!name = %!planet_hash<name>; }
    method x    { return $!x if defined $!x or not defined %!planet_hash<x>; $!x = %!planet_hash<x>.Int; }
    method y    { return $!y if defined $!y or not defined %!planet_hash<y>; $!y = %!planet_hash<y>.Int; }
}#}}}

class Games::Lacuna::Model::SupplyChain does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.id;
    has Int $.resource_hour;
    has Str $.resource_type;
    has Int $.percent_transferred;
    has Bool $.stalled;
    has Games::Lacuna::Model::SupplyChain::FromBody $.from_body;
    method id                   { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method resource_hour        { return $!resource_hour if defined $!resource_hour or not defined %.json<resource_hour>; $!resource_hour = %.json<resource_hour>.Int; }
    method resource_type        { return $!resource_type if defined $!resource_type or not defined %.json<resource_type>; $!resource_type = %.json<resource_type>; }
    method percent_transferred  { return $!percent_transferred if defined $!percent_transferred or not defined %.json<percent_transferred>; $!percent_transferred = %.json<percent_transferred>.Int; }
    method stalled              { return $!stalled if defined $!stalled or not defined %.json<stalled>; $!stalled = %.json<stalled>.Int.Bool; }
    method from_body {
        return $!from_body if defined $!from_body or not defined %.json<from_body>;
        $!from_body = Games::Lacuna::Model::SupplyChain::FromBody.new( :planet_hash(%.json<from_body>) );
    }

}#}}}



 # vim: syntax=perl6 fdm=marker

