#!/usr/bin/env perl

use v5.10;

my @beach = qw(
    beach1
    beach2
    beach3
    beach4
    beach5
    beach6
    beach7
    beach8
    beach9
    beach10
    beach11
    beach12
    beach13
);
my @boring = qw(
    algae
    apple
    atmosphericevaporator
    bean
    beeldeban
    bread
    burger
    cheese
    chip
    cider
    cloakinglab
    corn
    cornmeal
    crater
    dairy
    denton
    deployedbleeder
    energyreserve
    espionage
    fission
    fissure
    foodreserve
    fusion
    gasgiantlab
    gasgiantplatform
    geo
    greatballofjunk
    grove
    hydrocarbon
    junkhengesculpture
    lagoon
    lake
    lapis
    luxuryhousing
    malcud
    metaljunkarches
    mine
    munitionslab
    orerefinery
    orestorage
    pancake
    pie
    pilottraining
    propulsion
    pyramidjunksculpture
    ravine
    rockyoutcrop
    sand
    saw
    shake
    singularity
    soup
    spacejunkpark
    sslb
    sslc
    ssld
    stockpile
    supplypod
    syrup
    terraforminglab
    terraformingplatform
    university
    wastedigester
    wasteenergy
    wasteexchanger
    wasterecycling
    wastesequestration
    wastetreatment
    waterproduction
    waterpurification
    waterreclamation
    waterstorage
    wheat
);
my @lcot = qw(
    lcota
    lcotb
    lcotc
    lcotd
    lcote
    lcotf
    lcotg
    lcoth
    lcoti
);
my @callable = qw(
    archaeology
    capitol
    development
    distributioncenter
    embassy
    entertainment
    geneticslab
    intelligence
    mercenariesguild
    miningministry
    missioncommand
    network19
    observatory
    park
    planetarycommand
    security
    shipyard
    spaceport
    ssla
    themepark
    trade
    transporter
);
my @training = qw(
    inteltraining
    mayhemtraining
    politicstraining
    thefttraining
);
my @glyph = qw(
    algaepond
    amalgusmeadow
    beeldebannest
    blackholegenerator
    citadelofknope
    crashedshipsite
    dentonbrambles
    essentiavein
    geothermalvent
    gratchsgauntlet
    hallsofvrbansk
    interdimensionalrift
    kalavianruins
    kasternskeep
    lapisforest
    libraryofjith
    malcudfield
    massadshenge
    naturalspring
    oracleofanid
    pantheonofhagness
    subspacesupplydepot
    templeofthedrajilites
    thedillonforge
    volcano
);
my @ss = qw(
    artmuseum
    culinaryinstitute
    ibs
    operahouse
    parliament
    policestation
    stationcommand
    warehouse
);
my @all = ( @beach, @boring, @lcot, @callable, @training, @glyph, @ss );

#for my $m(@all) { make_module($m); }

make_group_module('Beach.pm6', @beach);
make_group_module('Boring.pm6', @boring);
make_group_module('LCOT.pm6', @lcot);
make_group_module('Callable.pm6', @callable);
make_group_module('Training.pm6', @training);
make_group_module('Glyph.pm6', @glyph);
make_group_module('SS.pm6', @ss);



sub make_group_module {#{{{
    my $file_name   = shift;
    my @classes     = @_;

    open my $g, '>', $file_name or die $!;
    say $g "use Games::Lacuna::Model::Building::BuildingRole;";
    say $g '';
    for my $c(@classes) {
        say $g "class Games::Lacuna::Model::Building::Buildings::$c does Games::Lacuna::Model::Building::BuildingRole {}";
    }
    say $g '';
    close $g;

}#}}}
sub make_module {#{{{
    my $m = shift;

    open my $f, '>', "$m.pm6" or die $!;
    print $f "
use Games::Lacuna::Model::Building::BuildingRole;
class Games::Lacuna::Model::Building::Buildings::$m does Games::Lacuna::Model::Building::BuildingRole {}
    ";
    close $m;
}#}}}

