#!/usr/bin/env perl6


if True {# {{{

use lib 'lib';

use Games::Lacuna::Model::Body;
use Games::Lacuna::Model::Body::OwnPlanet;
use Games::Lacuna::Model::Body::ForeignPlanet;

my $jontest = Games::Lacuna::Model::Body.new( :body_name('bmots07') );
say $jontest.body_name; exit;

say "foo";


}# }}}



