
use Games::Lacuna::Account;

#|
role Games::Lacuna::Model {#{{{
    has Games::Lacuna::Account $account;
    has Str $.endpoint_name;
    has %.json_parsed;
}#}}}

 # vim: syntax=perl6 fdm=marker

