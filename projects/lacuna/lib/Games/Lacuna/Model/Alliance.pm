
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;


class Games::Lacuna::Model::Alliance::Member does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;

    submethod BUILD (:%!json!) { }
    method id   { return $!id if defined $!id or not defined %!json<id>; $!id = %!json<id>.Int; }
    method name { return $!name if defined $!name or not defined %!json<name>; $!name = %!json<name>; }
}#}}}
class Games::Lacuna::Model::Alliance::SS does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;
    has Int $.x;
    has Int $.y;

    submethod BUILD (:%!json!) { }
    method id   { return $!id if defined $!id or not defined %!json<id>; $!id = %!json<id>.Int; }
    method name { return $!name if defined $!name or not defined %!json<name>; $!name = %!json<name>; }
    method x   { return $!x if defined $!x or not defined %!json<x>; $!x = %!json<x>.Int; }
    method y   { return $!y if defined $!y or not defined %!json<y>; $!y = %!json<y>.Int; }
}#}}}

class Games::Lacuna::Model::Alliance::FullAlliance does Games::Lacuna::Model {#{{{
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
            $id - Int                   Optional.  Defaults to the current user's
                                        alliance ID.  If the current user is not 
                                        in an alliance, this argument is required.
        Examples:
            my $ally = Games::Lacuna::Model::Alliance.new( :$account );
            my $ally = Games::Lacuna::Model::Alliance.new(  :$account, :id(123) );
    #}
    submethod BUILD (:$account!, Int :$id) {#{{{
        $!account       = $account;
        $!id            = $id;
        $!endpoint_name = 'alliance';
        my %rv          = $account.send(
            :$!endpoint_name, :method('view_profile'),
            [$account.session_id, $!id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><profile>;
    }#}}}

    method id               { return $!id if defined $!id or not defined %!json<id>; $!id = %!json<id>.Int; }
    method name             { return $!name if defined $!name or not defined %!json<name>; $!name = %!json<name>; }
    method description      { return $!description if defined $!description or not defined %!json<description>; $!description = %!json<description>; }
    method leader_id        { return $!leader_id if defined $!leader_id or not defined %!json<leader_id>; $!leader_id = %!json<leader_id>.Int; }
    method date_created     { return $!date_created if defined $!date_created or not defined %!json<date_created>; $!date_created = Games::Lacuna::DateTime.from_tle(%!json<date_created>); }
    method influence        { return $!influence if defined $!influence or not defined %!json<influence>; $!influence = %!json<influence>.Int; }

    method members {
        return @!members if @!members.elems > 0 or not defined %!json<members>;
        for %!json<members>.values -> %m {
            @!members.push( Games::Lacuna::Model::Alliance::Member.new(:json(%m)) );
        }
        @!members;
    }
    method space_stations {
        return @!space_stations if @!space_stations.elems > 0 or not defined %!json<space_stations>;
        for %!json<space_stations>.values -> %s {
            @!space_stations.push( Games::Lacuna::Model::Alliance::SS.new(:json(%s)) );
        }
        @!space_stations;
    }

}#}}}
class Games::Lacuna::Model::Alliance::PartialAlliance does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;
    method id               { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method name             { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
}#}}}

#|{
    Factory class.

            $some_alliance      = Games::Lacuna::Model::Alliance.new( :$account, :$id );
            $other_alliance     = Games::Lacuna::Model::Alliance.new( :$account, :$name );
            $my_alliance        = Games::Lacuna::Model::Alliance.new( :$account );
            $partial_alliance   = Games::Lacuna::Model::Alliance.new( :$json );

    When searching for an alliance by name, your best bet is to pass the full 
    alliance name (eg "The Understanding").  However, passing just a partial 
    alliance name will work under these conditions:
        - The partial name is at least three characters long
        - The partial name is unambiguous.

        This works fine, because no other alliance name starts with "The Under":
            my $tu = Games::Lacuna::Model::Alliance.new(:account($a), :name('The Under'));

        However, this is not fine.  The partial name given matches both "The 
        Understanding" and "The Fist" (and there may be others).  So this throws an exception:
            my $tu = Games::Lacuna::Model::Alliance.new(:account($a), :name('The'));

    A partial alliance is just a subset of Alliance-related data that 
    sometimes gets handed back in another request.
#}
class Games::Lacuna::Model::Alliance {#{{{

    multi method new (:$account!, Str :$name! where {$name.chars >= 3}) {#{{{
        ### We can only create an Alliance object by ID.  To find an 
        ### alliance's ID given its name, we have to look in stats.
        my %rv = $account.send(
            :endpoint_name('stats'), :method('find_alliance_rank'),
            [$account.session_id, 'average_empire_size_rank', $name]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %rv<result><alliances>.elems < 1 && die "'$name': No such alliance.";
        %rv<result><alliances>.elems == 1 && return Games::Lacuna::Model::Alliance::FullAlliance.new(:$account, :id(%rv<result><alliances>[0]<alliance_id>.Int) );

        ### find_alliance_rank returns a list of alliances that match the 
        ### passed-in $name.  If these two alliances exist:
        ###     United Group
        ###     United Group of Unison
        ### ...then when you search by name for "United Group", you're going 
        ### to get both alliances returned.  The order in which they're 
        ### returned is not defined.
        ###
        ### Since this method needs to return exactly one alliance, we need to 
        ### filter the list ourselves.
        my $ally_hash = %rv<result><alliances>.grep({$_<alliance_name>.lc eqv $name.lc})[0];
        $ally_hash && return Games::Lacuna::Model::Alliance::FullAlliance.new(:$account, :id($ally_hash<alliance_id>.Int) );
        die "'$name': No such alliance.";
    }#}}}
    multi method new (:$account!, Int :$id!) {#{{{
        return Games::Lacuna::Model::Alliance::FullAlliance.new(:$account, :$id);
    }#}}}
    multi method new (:$account!) {#{{{
        return Games::Lacuna::Model::Alliance::FullAlliance.new(:$account);
    }#}}}
    multi method new (:%json!) {#{{{
        return Games::Lacuna::Model::Alliance::PartialAlliance.new(:%json);
    }#}}}
 
}#}}}

 # vim: syntax=perl6 fdm=marker

