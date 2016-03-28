
#|{
    Factory class.

    Depending upon arguments, returns one of:
        Games::Lacuna::Model::Body::OwnPlanet
        Games::Lacuna::Model::Body::OwnSS
        Games::Lacuna::Model::Body::ForeignPlanet
        Games::Lacuna::Model::Body::ForeignSS

    The Own* classes refer to a body owned by the user or his alliance, and 
    implement the various Body methods.
        https://us1.lacunaexpanse.com/api/Body.html

    The Foreign* classes generally get handed back as part of another 
    response.  eg a user's PublicProfile contains a list of known_colonies, 
    which will become a list of ForiegnPlanet objects.  These are mostly just 
    collections of data.  You can't call methods on a Body that's not yours.

    What Body attributes actually get set in the Foriegn* classes vary, but 
    id, name, x, and y are pretty common.

    Examples:
            my $own_planet = Games::Lacuna::Model::Body.new( :$account, :body_name("Earth") );      # name of a planet
            my $own_planet = Games::Lacuna::Model::Body.new( :$account, :body_id(12345) );          # ID of a planet

        "own station" doesn't need to be a station your account personally 
        owns.  It can be controlled by any member of your alliance.
            my $own_station = Games::Lacuna::Model::Body.new( :$account, :body_name("ISS") );       # name of a station
            my $own_station = Games::Lacuna::Model::Body.new( :$account, :body_id(23456) );         # ID of a station

        When another response hands you back a small hash of details about a 
        planet or station:
            my %p = %resp<keys><to><planet_details>;
            my %s = %resp<keys><to><station_details>;
            my $for_planet  = Games::Lacuna::Model::Body.new( :planet_hash(%p) );
            my $for_station = Games::Lacuna::Model::Body.new( :station_hash(%s) );
#}
class Games::Lacuna::Model::Body {
    use Games::Lacuna::Model::Body::OwnPlanet;         # this is the problem
    use Games::Lacuna::Model::Body::OwnSS;
    use Games::Lacuna::Model::Body::ForeignPlanet;
    use Games::Lacuna::Model::Body::ForeignSS;

    multi method new (:$account!, :$body_name!) {
        return Games::Lacuna::Model::Body::OwnPlanet.new(:$account, :body_id($account.mycolonies<names>{$body_name}))    if $account.mycolonies<names>{$body_name};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :body_id($account.mystations<names>{$body_name}))    if $account.mystations<names>{$body_name};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :body_id($account.ourstations<names>{$body_name}))   if $account.ourstations<names>{$body_name};
        die "You can only access a body by name if you own it.";
    }
    multi method new (:$account!, :$body_id!) {
        return Games::Lacuna::Model::Body::OwnPlanet.new(:$account, :$body_id)  if $account.mycolonies<ids>{$body_id};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :$body_id)  if $account.mystations<ids>{$body_id};
        return Games::Lacuna::Model::Body::OwnSS.new(:$account,     :$body_id)  if $account.ourstations<ids>{$body_id};
        die "You can only access a body by ID if you own it.";
    }
    multi method new (:%planet_hash!) {
        return Games::Lacuna::Model::Body::ForeignPlanet.new(:%planet_hash);
    }
    multi method new (:%station_hash!) {
        return Games::Lacuna::Model::Body::ForeignSS.new(:%station_hash);
    }

}


 # vim: syntax=perl6 fdm=marker

