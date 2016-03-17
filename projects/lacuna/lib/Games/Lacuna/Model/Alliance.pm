
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

class Games::Lacuna::Model::Alliance::Member does Games::Lacuna::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;

    submethod BUILD (:%!json_parsed!) { }
    method id   { return $!id if defined $!id or not defined %!json_parsed<id>; $!id = %!json_parsed<id>.Int; }
    method name { return $!name if defined $!name or not defined %!json_parsed<name>; $!name = %!json_parsed<name>; }
}#}}}
class Games::Lacuna::Model::Alliance::SS does Games::Lacuna::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;
    has Int $.x;
    has Int $.y;

    submethod BUILD (:%!json_parsed!) { }
    method id   { return $!id if defined $!id or not defined %!json_parsed<id>; $!id = %!json_parsed<id>.Int; }
    method name { return $!name if defined $!name or not defined %!json_parsed<name>; $!name = %!json_parsed<name>; }
    method x   { return $!x if defined $!x or not defined %!json_parsed<x>; $!x = %!json_parsed<x>.Int; }
    method y   { return $!y if defined $!y or not defined %!json_parsed<y>; $!y = %!json_parsed<y>.Int; }
}#}}}
class Games::Lacuna::Model::Alliance does Games::Lacuna::Model {#{{{
    has %.p;                        # convenience -- just %.json_parsed<result><profile>.  Handled by BUILD.
    has Int $.id;
    has Str $.name;
    has Str $.description;
    has Int $.leader_id;
    has Games::Lacuna::DateTime $.date_created;
    has Games::Lacuna::Model::Alliance::Member @.members;
    has Games::Lacuna::Model::Alliance::SS @.space_stations;
    has Int $.influence;

    #|{
        Args:
            $account - GL::Account      Required.
            $alliance_id - Int          Optional.  Defaults to the current user's
                                        alliance ID.  If the current user is not 
                                        in an alliance, this argument is required.
        Examples:
            my $ally = Games::Lacuna::Model::Alliance.new();
            my $ally = Games::Lacuna::Model::Alliance.new( :alliance_id(123) );
    #}
    proto method BUILD (:$account!, :$alliance_id) {#{{{
        {*};
        $!account       = $account;
        $!endpoint_name = 'alliance';
        %!json_parsed   = $account.send(
            :$!endpoint_name, :method('view_profile'),
            [$account.session_id, $!id]
        );
        die Games::Lacuna::Exception.new(%!json_parsed) if %!json_parsed<error>;
        try { %!p = %!json_parsed<result><profile> };
    }#}}}
    multi submethod BUILD (:$account!, :$alliance_id!) {#{{{
        $!id = $alliance_id;
    }#}}}
    multi submethod BUILD (:$account!) {#{{{
        $!id = $account.alliance_id;
    }#}}}

    method id               { return $!id if defined $!id or not defined %!p<id>; $!id = %!p<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!p<name>; $!name = %!p<name>; }
    method description      { return $!description if defined $!description or not defined %!p<description>; $!description = %!p<description>; }
    method leader_id        { return $!leader_id if defined $!leader_id or not defined %!p<leader_id>; $!leader_id = %!p<leader_id>.Int; }
    method date_created     { return $!date_created if defined $!date_created or not defined %!p<date_created>; $!date_created = Games::Lacuna::DateTime.from_tle(%!p<date_created>); }
    method influence        { return $!influence if defined $!influence or not defined %!p<influence>; $!influence = %!p<influence>.Int; }

    method members {
        return @!members if @!members.elems > 0 or not defined %!p<members>;
        for %!p<members>.values -> %m {
            @!members.push( Games::Lacuna::Model::Alliance::Member.new(:json_parsed(%m)) );
        }
        @!members;
    }
    method space_stations {
        return @!space_stations if @!space_stations.elems > 0 or not defined %!p<space_stations>;
        for %!p<space_stations>.values -> %s {
            @!space_stations.push( Games::Lacuna::Model::Alliance::SS.new(:json_parsed(%s)) );
        }
        @!space_stations;
    }

}#}}}


 # vim: syntax=perl6 fdm=marker

