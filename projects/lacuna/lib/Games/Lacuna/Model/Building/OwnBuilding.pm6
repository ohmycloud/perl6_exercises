
use Games::Lacuna::Model::Building::BuildingRole;
class Games::Lacuna::Model::Building::OwnBuilding does Games::Lacuna::Model::Building::BuildingRole {
    use Games::Lacuna::Model::Building::Buildings;
    method enter() {
        use MONKEY-SEE-NO-EVAL;
        return EVAL 'Games::Lacuna::Model::Building::Buildings::' ~ $.type ~ '.new( :$.account, :%.json )';
   }
}

