
#use Games::Lacuna::Model::Body::ForeignBodyRole;
#class Games::Lacuna::Model::Body::ForeignPlanet does Games::Lacuna::Model::Body::ForeignBodyRole {
#    submethod BUILD (:%planet_hash) {
#        %!json   = %planet_hash;
#    }
#}


use Games::Lacuna::Model::NonCommModel;
use Games::Lacuna::Model::Body::BodyRole;
class Games::Lacuna::Model::Body::ForeignPlanet does Games::Lacuna::Model::NonCommModel does Games::Lacuna::Model::Body::BodyRole {
    submethod BUILD (:%planet_hash) {
        %!json   = %planet_hash;
    }
}

 # vim: syntax=perl6 fdm=marker

