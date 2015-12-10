
if True {
    my $greet = "Hello, World!";
    say $greet.WHAT;
    say $greet.perl;
    say $greet;

    for ^4 {
        say "$^b follows $^a";
    }

    sayit('foo');
}

sub sayit {
    say "$^a $^b";
}

