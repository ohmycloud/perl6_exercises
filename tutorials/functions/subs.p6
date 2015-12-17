#!/home/jon/.rakudobrew/bin/perl6

sub no_args {
    say "No args, no prototype, no signature.";
}

sub greet_sig ($name) {
    say "Hello, $name!";
}

sub greet_sig_constraint (Str $name) {
    say "Hello, $name!";
}

class Person {
    method whatami( $me: ) {
        say "I'm a member of $me.^name()"
    }
}
my $p = Person.new();
$p.whatami;
''.say;



sub greet ($greeting, *@names) {
    for @names -> $a {
        say "$greeting, $a!";
    }
}
my @arr = <jon john kermit>;
greet("Hello", @arr, "Alison");
''.say;


sub greet_named( $pos, :$greeting!, :$name! ) {
    say "$greeting, $name! ($pos)"
}
greet_named( 'bar', name => 'Steve', greeting => 'Hola' );
''.say;


sub the_answer( Int $ans = 42 ) {
    say "The answer is $ans.";
}
the_answer();
the_answer(11);
''.say;


sub the_answer_opt( Int $ans? ) {
    if $ans {
        say "The answer is $ans.";
    }
    else {
        say "I dunno the answer.";
    }
}
the_answer_opt(11);
the_answer_opt();
''.say;


@arr = <jon red blue yellow orange>;
sub likes_colors (@arr ($name, *@colors) ) {
    for @colors -> $c {
        say "$name likes $c.";
    }
}
likes_colors(@arr);


sub likes_colors_2 ( [$name, *@colors] ) {
    for @colors -> $c {
        say "$name likes $c.";
    }
}
likes_colors_2(@arr);
''.say;



sub hello_copy ($name is copy) {
    $name = $name.uc;
    say $name;

}
my $name = 'jon';
hello_copy($name);
say $name;


sub hello_clobber ($name is rw) {
    $name = $name.uc;
    say $name;

}
my $name = 'jon';
hello_clobber($name);
say $name;
''.say;


sub set_var(\variable) {
    variable = "foobar";
}
set_var( my $foo );
say $foo;

















