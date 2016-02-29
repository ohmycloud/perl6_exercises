#!/home/jon/.rakudo/install/bin/perl6


sub greet (Str:_ $name) {
    say $name ?? "Hello, $name!" !! "You didn't send me a name.";
}


my Str $var;
greet($var);
say "--------------";
exit;





            sub lower-right ( $x where {$x > 0}, $y where {$y < 0}, $foo = 'bar' --> Str ) {
                "Your point is located at ($x, $y).";
            }

            say &lower-right.signature.perl;
            say &lower-right.signature.arity;
            say &lower-right.signature.returns;
''.say;

            say &lower-right.signature.params;
            say &lower-right.signature.params[0].sigil;
            say &lower-right.signature.params[0].name;
            say &lower-right.signature.params[0].type;

