
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

    use Games::Lacuna::Exception;
    use Games::Lacuna::Model::Alliance::FullAlliance;
    use Games::Lacuna::Model::Alliance::PartialAlliance;

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
        die "You are not in an alliance." unless $account.alliance_id;
        return Games::Lacuna::Model::Alliance::FullAlliance.new( :$account, :id($account.alliance_id) );
    }#}}}
    multi method new (:%json!) {#{{{
        return Games::Lacuna::Model::Alliance::PartialAlliance.new(:%json);
    }#}}}
 
}#}}}

 # vim: syntax=perl6 fdm=marker

