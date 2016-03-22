
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

=begin pod

=head1 SYNOPSIS
Medal data are returned in a user's profile as a hash with the medal ID as the key:
    "profile" : {
        "medals" : {
            "id-goes-here" : {
                "name" : "Built Level 1 Building",
                "image" : "building1",
                "date" : "01 31 2010 13:09:05 +0600",
                "public" : 1,
                "times_earned" : 4
            },
            ...
        },
        ...non-medal-related stuff....
    }

Create a new medal object:
    my %medal_hash  = %resp<profile><medals>{$some_id};
    my $medal       = Games::Lacuna::Model::Medal.new( %medal_hash );

The individual medal hash does I<not> contain the medal ID, since that ID is 
the key pointing at the medal hash.  If you wish, you can modify the 
individual medal hash to add the ID first with something like:
    for %resp<profile><medals>.kv -> $id, %individual_medal_hash {
        %individual_medal_hash<id> = $id;
        my $medal = Games::Lacuna::Model::Medal.new( %individual_medal_hash );
    }

But you're probably never going to care what a Medal's ID is, and omitting it 
won't hurt anything.

=head2 times_earned
The 'times_earned' attribute can be a bit confusing, especially for buildings. 
The medal for building a specific building (eg "Built University") is actually 
awarded for each time that building is leveled up.

If you downgrade a maxed building and then level it up again, you I<are> 
awarded the medal again.

=end pod

#| A user's profile will include zero or more medals.
#|      my $medal = Games::Lacuna::Model::Medal.new( %resp<profile><medals>{$id>} );
class Games::Lacuna::Model::Medal does Games::Lacuna::Model::NonCommModel {#{{{
    has Int $.id;
    has Str $.name;
    has Str $.image;
    has Games::Lacuna::DateTime $.date;
    has Bool $.public;
    has Int $.times_earned;

    method id           { return $!id if defined $!id or not defined %!json_parsed<id>; $!id = %!json_parsed<id>.Int; }
    method name         { return $!name if defined $!name or not defined %!json_parsed<name>; $!name = %!json_parsed<name>; }
    method image        { return $!image if defined $!image or not defined %!json_parsed<image>; $!image = %!json_parsed<image>; }
    method date         { return $!date if defined $!date or not defined %!json_parsed<date>; $!date = Games::Lacuna::DateTime.from_tle(%!json_parsed<date>); }
    method times_earned { return $!times_earned if defined $!times_earned or not defined %!json_parsed<times_earned>; $!times_earned = %!json_parsed<times_earned>.Int; }

=for comment
    %medal<public> is either 0 or 1.  But TLE, for whatever reason, returns 
    everything as strings, so a "not public" medal will actually be listed as 
    %medal<public> = "0".
    Since string zero is now True, we have to cast that <public> value to an 
    Int before checking on its Boolean-ness.

    method public       { return $!public if defined $!public or not defined %!json_parsed<public>; $!public = %!json_parsed<public>.Int.Bool; }
}#}}}



 # vim: syntax=perl6 fdm=marker

