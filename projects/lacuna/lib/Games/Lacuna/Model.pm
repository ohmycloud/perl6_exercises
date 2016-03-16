
use Games::Lacuna::Account;

#| Most models need to be able to talk to the TLE server, so need an active account object and an endpoint name.
role Games::Lacuna::Model {#{{{
    has Games::Lacuna::Account $account;
    has Str $.endpoint_name;
    has %.json_parsed;
}#}}}

#| A few models are just collections of data and never need to talk to TLE.
role Games::Lacuna::NonCommModel {#{{{
    has %.json_parsed;
}#}}}

 # vim: syntax=perl6 fdm=marker

