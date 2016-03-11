
use Games::Lacuna;

#|
role Games::Lacuna::Model is Games::Lacuna::Comms {#{{{
    has Str $.endpoint_name;
    has Str $.json_str;
    has Str %.json_parsed;

    method get_key(Str $name) {
        %!json_parsed ||= from-json($!json_string);
        return %!json_parsed{$name} || Nil;
    }
}#}}}

 # vim: syntax=perl6 fdm=marker

