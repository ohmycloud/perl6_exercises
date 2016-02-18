#!/home/jon/.rakudobrew/bin/perl6


use v6;

grammar KeyValuePairs {
    token TOP {
        [<pair> \n+]*
    }
    token ws { \h* }

    rule pair {
        <key=.identifier> '=' <value=.identifier>
    }
    token identifier {
        \w+
    }
}

class KeyValuePairsActions {
    method identifier($/) { $/.make: ~$/                          }
    method pair      ($/) { $/.make: $<key>.made => $<value>.made }
    method TOP       ($/) { $<pair>».made.say; $/.make: $<pair>».made                }
}

my  $res = KeyValuePairs.parse(q:to/EOI/, :actions(KeyValuePairsActions)).made;
    second=b
    hits=42
    perl=6
    EOI

for @$res -> $p {
    say "Key: $p.key()\tValue: $p.value()";
}
