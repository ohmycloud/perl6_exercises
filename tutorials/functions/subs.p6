#!/home/jon/.rakudobrew/bin/perl6


#sub jontest(Str $foo, Int $bar, Str $baz) { }
#say &jontest.signature.perl;
#exit;

my $jt = sub jontest(Str $foo, Int $bar, Str $baz) { }
$jt.signature.perl.say;
exit;




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
my $fname = 'jon';
hello_clobber($fname);
say $fname;
''.say;


sub set_var(\variable) {
    variable = "foobar";
}
set_var( my $foo );
say $foo;
''.say;



multi hello() {
    say "Why hello there.";
}
multi hello(Str $name) {
    say "Hello, $name, nice to meet you.";
}
multi hello(Int $num) {
    say "y helo thar " x $num;
}
hello();
hello('Jon');
hello(3);
''.say;




proto congratulate(Str $reason, Str $name, |) {*}
multi congratulate($reason, $name) {
   say "Hooray for your $reason, $name";
}
multi congratulate($reason, $name, Int $rank) {
   say "Hooray for your $reason, $name -- you got rank $rank!";
}

congratulate('birthday', 'jon');
congratulate('birthday', 'jon', 2);
''.say;


proto notify(Str $user, |) {
    my \hour = DateTime.now.hour;
    ### Print out hour here and then modify the conditional if you want to see 
    ### the else block hit.
    #say hour;
    if hour > 8 and hour < 16 {
        return {*};
    }
    else {
        # we can't notify someone when they might be sleeping
        return False;
    }
}
multi notify($user, Str $msg) {
    say "I'm going to send message '$msg' to user '$user'.";
}
multi notify($user, Int $code) {
    say "I'm going to send error code $code to user '$user'.";
}
notify('jon', 'error happened');
notify('jon', 3001);
''.say;



class Peeple {
    has Int $.age;
}
my $p1 = Peeple.new( age => 10 );
my $p2 = Peeple.new( age => 20 );
multi infix:<+>(Peeple $a, Peeple $b) { $a.age + $b.age }
say $p1 + $p2;
''.say;


multi trait_mod:<is>(Routine $r, :$doubles!) {
    $r.wrap({
        2 * callsame;
    });
}
sub square($x) is doubles { $x * $x }
say square 3;   # 18
''.say;



multi a(Any $x) { say "Any $x" }
multi a(Int $x) { say "Int $x"; callwith($x + 1); say "Back in Int $x." }
a(1);
''.say;

multi b(Any $x) { say "Any $x" }
multi b(Int $x) { say "Int $x"; callsame; say "Back in Int $x." }
b(1);
''.say;

multi c(Any $x) { say "Any $x"; return $x + 3; }
multi c(Int $x) {
    say "Int $x";
    my $rv = callsame;
    say "Back in Int $x, got $rv."
}
c(1);
''.say;

multi d(Any $x) { say "Any $x" }
multi d(Int $x) { say "Int $x"; nextsame; say "Back in Int $x." }
d(1);
''.say;



class MyParent {
    method new(|c) {
        say "Parent class has the arguments " ~ c.perl;
    }
}
class MyKid is MyParent {
    method new(|c) {
        note "Creating a new kid with the arguments " ~ c.perl;
        nextsame;   # calls MyParent.new()
    }
}
my $kid1 = MyKid.new();
''.say;
my $kid2 = MyKid.new('foobar');
''.say;
my $kid3 = MyKid.new("blarg", <a b c>, {jon => 'barton'}, 733, color => 'red');
''.say;



sub double(Int(Cool) $x) {
    2 * $x;
}
say double 21;
say double '21';    # wouldn't have worked if our sig required an Int.
say double "foobar";





