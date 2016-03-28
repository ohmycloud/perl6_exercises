
class Games::Lacuna::Model::Body::UtilInfluence {
    has %.influence;
    has Int $.total;
    has Int $.spent;
    method total   { return $!total if defined $!total or not defined %!influence<total>; $!total = %!influence<total>.Int; }
    method spent   { return $!spent if defined $!spent or not defined %!influence<spent>; $!spent = %!influence<spent>.Int; }
}

 # vim: syntax=perl6 fdm=marker

