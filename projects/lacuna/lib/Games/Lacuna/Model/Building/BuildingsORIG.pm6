

### test.p6 works if we uncomment down to beach11 inclusive.
###
### But if we uncomment just one more "use" statement, test.p6 fails.  I have 
### no idea what to do about this.



### This is up here just because test.p6 is specifically trying to use it.
use Games::Lacuna::Model::Building::Buildings::planetarycommand;


### General buildings that don't have any specific methods of their own.
### There is no need to ever instantiate any of these buildings.  The modules 
### exist only to keep the code from blowing up in case somebody accidentally 
### does instantiate one.
use Games::Lacuna::Model::Building::Buildings::algae;
use Games::Lacuna::Model::Building::Buildings::apple;
use Games::Lacuna::Model::Building::Buildings::atmosphericevaporator;
use Games::Lacuna::Model::Building::Buildings::beach1;
use Games::Lacuna::Model::Building::Buildings::beach2;
use Games::Lacuna::Model::Building::Buildings::beach3;
use Games::Lacuna::Model::Building::Buildings::beach4;
use Games::Lacuna::Model::Building::Buildings::beach5;
use Games::Lacuna::Model::Building::Buildings::beach6;
use Games::Lacuna::Model::Building::Buildings::beach7;
use Games::Lacuna::Model::Building::Buildings::beach8;
use Games::Lacuna::Model::Building::Buildings::beach9;
use Games::Lacuna::Model::Building::Buildings::beach10;
use Games::Lacuna::Model::Building::Buildings::beach11;     # this is the last one that works when PCC is enabled up top.
=begin pod
use Games::Lacuna::Model::Building::Buildings::beach12;         
use Games::Lacuna::Model::Building::Buildings::beach13;
use Games::Lacuna::Model::Building::Buildings::bean;
use Games::Lacuna::Model::Building::Buildings::beeldeban;
use Games::Lacuna::Model::Building::Buildings::bread;
use Games::Lacuna::Model::Building::Buildings::burger;
use Games::Lacuna::Model::Building::Buildings::cheese;
use Games::Lacuna::Model::Building::Buildings::chip;
use Games::Lacuna::Model::Building::Buildings::cider;
use Games::Lacuna::Model::Building::Buildings::cloakinglab;
use Games::Lacuna::Model::Building::Buildings::corn;
use Games::Lacuna::Model::Building::Buildings::cornmeal;
use Games::Lacuna::Model::Building::Buildings::crater;
use Games::Lacuna::Model::Building::Buildings::dairy;
use Games::Lacuna::Model::Building::Buildings::denton;
use Games::Lacuna::Model::Building::Buildings::deployedbleeder;
use Games::Lacuna::Model::Building::Buildings::energyreserve;
use Games::Lacuna::Model::Building::Buildings::espionage;
use Games::Lacuna::Model::Building::Buildings::fission;
use Games::Lacuna::Model::Building::Buildings::fissure;
use Games::Lacuna::Model::Building::Buildings::foodreserve;
use Games::Lacuna::Model::Building::Buildings::fusion;
use Games::Lacuna::Model::Building::Buildings::gasgiantlab;
use Games::Lacuna::Model::Building::Buildings::gasgiantplatform;
use Games::Lacuna::Model::Building::Buildings::geo;
use Games::Lacuna::Model::Building::Buildings::greatballofjunk;
use Games::Lacuna::Model::Building::Buildings::grove;
use Games::Lacuna::Model::Building::Buildings::hydrocarbon;
use Games::Lacuna::Model::Building::Buildings::junkhengesculpture;
use Games::Lacuna::Model::Building::Buildings::lagoon;
use Games::Lacuna::Model::Building::Buildings::lake;
use Games::Lacuna::Model::Building::Buildings::lapis;
use Games::Lacuna::Model::Building::Buildings::lcota;
use Games::Lacuna::Model::Building::Buildings::lcotb;
use Games::Lacuna::Model::Building::Buildings::lcotc;
use Games::Lacuna::Model::Building::Buildings::lcotd;
use Games::Lacuna::Model::Building::Buildings::lcote;
use Games::Lacuna::Model::Building::Buildings::lcotf;
use Games::Lacuna::Model::Building::Buildings::lcotg;
use Games::Lacuna::Model::Building::Buildings::lcoth;
use Games::Lacuna::Model::Building::Buildings::lcoti;
use Games::Lacuna::Model::Building::Buildings::luxuryhousing;
use Games::Lacuna::Model::Building::Buildings::malcud;
use Games::Lacuna::Model::Building::Buildings::metaljunkarches;
use Games::Lacuna::Model::Building::Buildings::mine;
use Games::Lacuna::Model::Building::Buildings::munitionslab;
use Games::Lacuna::Model::Building::Buildings::orerefinery;
use Games::Lacuna::Model::Building::Buildings::orestorage;
use Games::Lacuna::Model::Building::Buildings::pancake;
use Games::Lacuna::Model::Building::Buildings::pie;
use Games::Lacuna::Model::Building::Buildings::pilottraining;
use Games::Lacuna::Model::Building::Buildings::propulsion;
use Games::Lacuna::Model::Building::Buildings::pyramidjunksculpture;
use Games::Lacuna::Model::Building::Buildings::ravine;
use Games::Lacuna::Model::Building::Buildings::rockyoutcrop;
use Games::Lacuna::Model::Building::Buildings::sand;
use Games::Lacuna::Model::Building::Buildings::saw;
use Games::Lacuna::Model::Building::Buildings::shake;
use Games::Lacuna::Model::Building::Buildings::singularity;
use Games::Lacuna::Model::Building::Buildings::soup;
use Games::Lacuna::Model::Building::Buildings::spacejunkpark;
use Games::Lacuna::Model::Building::Buildings::sslb;    # ssla has its own methods; the other three do not.
use Games::Lacuna::Model::Building::Buildings::sslc;
use Games::Lacuna::Model::Building::Buildings::ssld;
use Games::Lacuna::Model::Building::Buildings::stockpile;
use Games::Lacuna::Model::Building::Buildings::supplypod;
use Games::Lacuna::Model::Building::Buildings::syrup;
use Games::Lacuna::Model::Building::Buildings::terraforminglab;
use Games::Lacuna::Model::Building::Buildings::terraformingplatform;
use Games::Lacuna::Model::Building::Buildings::university;
use Games::Lacuna::Model::Building::Buildings::wastedigester;
use Games::Lacuna::Model::Building::Buildings::wasteenergy;
use Games::Lacuna::Model::Building::Buildings::wasteexchanger;
use Games::Lacuna::Model::Building::Buildings::wasterecycling;
use Games::Lacuna::Model::Building::Buildings::wastesequestration;
use Games::Lacuna::Model::Building::Buildings::wastetreatment;
use Games::Lacuna::Model::Building::Buildings::waterproduction;
use Games::Lacuna::Model::Building::Buildings::waterpurification;
use Games::Lacuna::Model::Building::Buildings::waterreclamation;
use Games::Lacuna::Model::Building::Buildings::waterstorage;
use Games::Lacuna::Model::Building::Buildings::wheat;


### Specialized regular buildings that do have their own methods
use Games::Lacuna::Model::Building::Buildings::archaeology;
use Games::Lacuna::Model::Building::Buildings::capitol;
use Games::Lacuna::Model::Building::Buildings::development;
use Games::Lacuna::Model::Building::Buildings::distributioncenter;
use Games::Lacuna::Model::Building::Buildings::embassy;
use Games::Lacuna::Model::Building::Buildings::entertainment;
use Games::Lacuna::Model::Building::Buildings::geneticslab;
use Games::Lacuna::Model::Building::Buildings::intelligence;
use Games::Lacuna::Model::Building::Buildings::mercenariesguild;
use Games::Lacuna::Model::Building::Buildings::miningministry;
use Games::Lacuna::Model::Building::Buildings::missioncommand;
use Games::Lacuna::Model::Building::Buildings::network19;
use Games::Lacuna::Model::Building::Buildings::observatory;
use Games::Lacuna::Model::Building::Buildings::park;
use Games::Lacuna::Model::Building::Buildings::planetarycommand;
use Games::Lacuna::Model::Building::Buildings::security;
use Games::Lacuna::Model::Building::Buildings::shipyard;
use Games::Lacuna::Model::Building::Buildings::spaceport;
use Games::Lacuna::Model::Building::Buildings::ssla;
use Games::Lacuna::Model::Building::Buildings::themepark;
use Games::Lacuna::Model::Building::Buildings::trade;
use Games::Lacuna::Model::Building::Buildings::transporter;

### Spy training buildings
use Games::Lacuna::Model::Building::Buildings::inteltraining;
use Games::Lacuna::Model::Building::Buildings::mayhemtraining;
use Games::Lacuna::Model::Building::Buildings::politicstraining;
use Games::Lacuna::Model::Building::Buildings::thefttraining;

### Glyph ("permanent") buildings
use Games::Lacuna::Model::Building::Buildings::algaepond;
use Games::Lacuna::Model::Building::Buildings::amalgusmeadow;
use Games::Lacuna::Model::Building::Buildings::beeldebannest;
use Games::Lacuna::Model::Building::Buildings::blackholegenerator;
use Games::Lacuna::Model::Building::Buildings::citadelofknope;
use Games::Lacuna::Model::Building::Buildings::crashedshipsite;
use Games::Lacuna::Model::Building::Buildings::dentonbrambles;
use Games::Lacuna::Model::Building::Buildings::essentiavein;
use Games::Lacuna::Model::Building::Buildings::geothermalvent;
use Games::Lacuna::Model::Building::Buildings::gratchsgauntlet;
use Games::Lacuna::Model::Building::Buildings::hallsofvrbansk;      # yes, plural
use Games::Lacuna::Model::Building::Buildings::interdimensionalrift;
use Games::Lacuna::Model::Building::Buildings::kalavianruins;
use Games::Lacuna::Model::Building::Buildings::kasternskeep;
use Games::Lacuna::Model::Building::Buildings::lapisforest;
use Games::Lacuna::Model::Building::Buildings::libraryofjith;
use Games::Lacuna::Model::Building::Buildings::malcudfield;
use Games::Lacuna::Model::Building::Buildings::massadshenge;
use Games::Lacuna::Model::Building::Buildings::naturalspring;
use Games::Lacuna::Model::Building::Buildings::oracleofanid;
use Games::Lacuna::Model::Building::Buildings::pantheonofhagness;
use Games::Lacuna::Model::Building::Buildings::subspacesupplydepot;
use Games::Lacuna::Model::Building::Buildings::templeofthedrajilites;
use Games::Lacuna::Model::Building::Buildings::thedillonforge;
use Games::Lacuna::Model::Building::Buildings::volcano;

### Space Station modules
use Games::Lacuna::Model::Building::Buildings::artmuseum;
use Games::Lacuna::Model::Building::Buildings::culinaryinstitute;
use Games::Lacuna::Model::Building::Buildings::ibs;
use Games::Lacuna::Model::Building::Buildings::operahouse;
use Games::Lacuna::Model::Building::Buildings::parliament;
use Games::Lacuna::Model::Building::Buildings::policestation;
use Games::Lacuna::Model::Building::Buildings::stationcommand;
use Games::Lacuna::Model::Building::Buildings::warehouse;

=end pod

