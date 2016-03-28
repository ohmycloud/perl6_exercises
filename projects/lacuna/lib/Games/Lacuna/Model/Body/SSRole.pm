

role Games::Lacuna::Model::Body::SSRole {
    use Games::Lacuna::Model::Alliance;
    use Games::Lacuna::Model::Body::UtilInfluence;

    has Games::Lacuna::Model::Alliance::PartialAlliance $.alliance;
    has Games::Lacuna::Model::Body::UtilInfluence $.influence;

    method alliance { return $!alliance if defined $!alliance or not defined %.json<alliance>; $!alliance = Games::Lacuna::Model::Alliance.new(:json(%.json<alliance>)); }
    method influence { return $!influence if defined $!influence or not defined %.json<influence>; $!influence = Games::Lacuna::Model::Body::UtilInfluence.new(:influence(%.json<influence>)); }
}

 # vim: syntax=perl6 fdm=marker

