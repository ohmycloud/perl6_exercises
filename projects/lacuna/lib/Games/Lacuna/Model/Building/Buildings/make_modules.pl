#!/usr/bin/env perl

my @mods = qw(
    algae
    apple
    atmosphericevaporator
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
    lcota
    lcotb
    lcotc
    lcotd
    lcote
    lcotf
    lcotg
    lcoth
    lcoti
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
    planetarycommand
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
    security
    shipyard
    spaceport
    ssla
    themepark
    trade
    transporter
    inteltraining
    mayhemtraining
    politicstraining
    thefttraining
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
    artmuseum
    culinaryinstitute
    ibs
    operahouse
    parliament
    policestation
    stationcommand
    warehouse
);

for my $m(@mods) {
    make_module($m);
}




sub make_module {
    my $m = shift;

    open my $f, '>', "$m.pm6" or die $!;
    print $f "
use Games::Lacuna::Model::Building::BuildingRole;
class Games::Lacuna::Model::Building::Buildings::$m does Games::Lacuna::Model::Building::BuildingRole {}
    ";
    close $m;
}





