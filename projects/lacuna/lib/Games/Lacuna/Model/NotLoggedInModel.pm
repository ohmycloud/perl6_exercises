
use Games::Lacuna::Comms;

role Games::Lacuna::Model::NotLoggedInModel does Games::Lacuna::Comms {
    has Str $.endpoint_name;
    has %.json;
}

 # vim: syntax=perl6 fdm=marker

