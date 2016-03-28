
use Games::Lacuna::Model::Body::SSRole;
use Games::Lacuna::Model::Body::ForeignBodyRole;

class Games::Lacuna::Model::Body::ForeignSS does Games::Lacuna::Model::Body::SSRole does Games::Lacuna::Model::Body::ForeignBodyRole {
    submethod BUILD (:%station_hash) { %!json = %station_hash; }
}

 # vim: syntax=perl6 fdm=marker

