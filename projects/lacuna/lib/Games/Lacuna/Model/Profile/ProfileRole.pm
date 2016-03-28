
use Games::Lacuna::Model;

role Games::Lacuna::Model::Profile::ProfileRole does Games::Lacuna::Model {
    use Games::Lacuna::Model::Alliance;
    use Games::Lacuna::DateTime;
    use Games::Lacuna::Model::Body;
    use Games::Lacuna::Model::Medal;

    has Int $.id;
    has Str $.name;
    has Str $.colony_count;
    has Str $.status_message;
    has Str $.description;
    has Str $.city;
    has Str $.country;
    has Str $.skype;
    has Str $.player_name;
    has Str $.species;
    has Games::Lacuna::Model::Medal @.medals;
    has Games::Lacuna::DateTime $.last_login;
    has Games::Lacuna::DateTime $.date_founded;
    has $.alliance;
    has @.known_colonies;

    method id               { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method name             { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
    method colony_count     { return $!colony_count if defined $!colony_count or not defined %.json<colony_count>; $!colony_count = %.json<colony_count>; }
    method status_message   { return $!status_message if defined $!status_message or not defined %.json<status_message>; $!status_message = %.json<status_message>; }
    method description      { return $!description if defined $!description or not defined %.json<description>; $!description = %.json<description>; }
    method city             { return $!city if defined $!city or not defined %.json<city>; $!city = %.json<city>; }
    method country          { return $!country if defined $!country or not defined %.json<country>; $!country = %.json<country>; }
    method skype            { return $!skype if defined $!skype or not defined %.json<skype>; $!skype = %.json<skype>; }
    method player_name      { return $!player_name if defined $!player_name or not defined %.json<player_name>; $!player_name = %.json<player_name>; }
    method last_login       { return $!last_login if defined $!last_login or not defined %.json<last_login>; $!last_login = Games::Lacuna::DateTime.from_tle(%.json<last_login>); }
    method date_founded     { return $!date_founded if defined $!date_founded or not defined %.json<date_founded>; $!date_founded = Games::Lacuna::DateTime.from_tle(%.json<date_founded>); }

    method alliance {#{{{
        return $!alliance if defined $!alliance or not defined %.json<alliance>;
        $!alliance = Games::Lacuna::Model::Alliance.new(:account($.account), :alliance_id(%.json<alliance><id>));
    }#}}}
    method medals {#{{{
        return @!medals if @!medals.elems > 0 or not defined %.json<medals>;
        for %.json<medals>.kv -> $id, %m {
            %m<id> = $id;
            @!medals.push( Games::Lacuna::Model::Medal.new(:json(%m)) );
        }
        @!medals;
   }#}}}
    method known_colonies {#{{{
        return @!known_colonies if @!known_colonies.elems > 0 or not defined %.json<known_colonies>;
        for %.json<known_colonies>.values -> %c {
            @!known_colonies.push( Games::Lacuna::Model::Body.new(:planet_hash(%c)) );
        }
        @!known_colonies;
   }#}}}

}

 # vim: syntax=perl6 fdm=marker

