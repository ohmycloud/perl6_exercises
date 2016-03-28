
use Games::Lacuna::Model;

class Games::Lacuna::Model::Alliance::FullAlliance does Games::Lacuna::Model {
    use Games::Lacuna::Exception;
    use Games::Lacuna::DateTime;
    use Games::Lacuna::Model::Alliance::Member;
    use Games::Lacuna::Model::Alliance::SS;

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
            my $ally = Games::Lacuna::Model::Alliance.new( :$account, :id(123) );
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

}

 # vim: syntax=perl6 fdm=marker

