
use Games::Lacuna::Model::NonCommModel;

role Games::Lacuna::Model::Building::Working does Games::Lacuna::Model::NonCommModel {#
    use Games::Lacuna::DateTime;

    has Int $.seconds_remaining;
    has Games::Lacuna::DateTime $.start;
    has Games::Lacuna::DateTime $.end;
    method new (:%json)  { self.bless(:%json); }
    method seconds_remaining    { return $!seconds_remaining if defined $!seconds_remaining or not defined %.json<seconds_remaining>; $!seconds_remaining = %.json<seconds_remaining>.Int; }
    method start                { return $!start if defined $!start or not defined %.json<start>; $!start = Games::Lacuna::DateTime.from_tle(%.json<start>); }
    method end                  { return $!end if defined $!end or not defined %.json<end>; $!end = Games::Lacuna::DateTime.from_tle(%.json<end>); }
}#

