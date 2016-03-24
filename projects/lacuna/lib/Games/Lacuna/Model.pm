
use Games::Lacuna::Account;
use Games::Lacuna::Comms;

#|{
    Models that need to be able to talk to the TLE server need an endpoint 
    name.
    Initial server comms (eg those involved with creating an empire) won't 
    have an account yet, since those comms are attempting to create an account 
    in the first place.  Those have an endpoint, but no account object.
}
role Games::Lacuna::Model::NotLoggedInModel does Games::Lacuna::Comms {#{{{
    has Str $.endpoint_name;
    has %.json;
}#}}}

#|{
    But most server comms make use of an already-created account.
#}
role Games::Lacuna::Model does Games::Lacuna::Model::NotLoggedInModel {#{{{
    has Games::Lacuna::Account $.account;
}#}}}

#|{
    A few models are just collections of data and never need to talk to TLE.
#}
role Games::Lacuna::Model::NonCommModel {#{{{
    has %.json;
}#}}}

 # vim: syntax=perl6 fdm=marker

