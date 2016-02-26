#!/home/jon/.rakudobrew/bin/perl6


{ # unicode variable names#{{{
    my $é = "this variable is unicode";
    say $é;
}#}}}
{ # Guillemets#{{{

my $a = «foobar»;
say $a;
''.say;

my @a = <1 2 3>;
@a «+=» 4;
#@a += 4;
say @a;

}#}}}
{ # Sets #{{{
    my @a = <foo bar baz>;
    my $var = 'ar';
    #if <<"∈">>($var, @a) {
    #if $var (elem) @a {
    if $var ∈ @a {
        say "It's in there.";
    }
}#}}}
{ # Mathematical Symbols #{{{
    my $var = 4²;
    say $var;           # 16

    $var = 4³;
    say $var;           # 64

    say π;              # 3.14159....
    ''.say;
}#}}}



