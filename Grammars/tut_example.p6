#!/home/jon/.rakudobrew/bin/perl6


### This is taken from
###     http://doc.perl6.org/language/grammars#Action_Objects


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


### The commented lines are the code as it appears in the tut.
###
### The uncommented lines are my modifications.  They do the same thing, but 
### mine are less noisy.
class KeyValuePairsActions {
    method identifier($/) { $/.make: ~$/                          }
    method pair      ($/) { make $<key>.made => $<value>.made }
    method TOP       ($/) { make $<pair>».made                }

    #method pair      ($/) { $/.make: $<key>.made => $<value>.made }
    #method TOP       ($/) { $/.make: $<pair>».made                }
}

my  $res = KeyValuePairs.parse(q:to/EOI/, :actions(KeyValuePairsActions)).made;
    second=b
    hits=42
    perl=6
    EOI

for @$res -> $p {
    say "Key: $p.key()\tValue: $p.value()";
}
