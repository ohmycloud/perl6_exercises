#!/home/jon/.rakudobrew/bin/perl6

=begin Foo

This is the example given in the docs, and it's a good one.

But it does take careful reading to understand what's happening.  And it might 
make you a little nauseated because of the use of globals.



When a sub uses a dynamic variable, it's pulling the variable's value from the 
perspective of the caller.


=end Foo



my $lexical   = 1;
my $*dynamic1 = 10;
my $*dynamic2 = 100;

sub say-all() {
    say "$lexical, $*dynamic1, $*dynamic2";
}

# prints 1, 10, 100
say-all();

{
    my $lexical   = 2;
    my $*dynamic1 = 11;
    $*dynamic2    = 101;

    # prints 1, 11, 101
    say-all();
}

# prints 1, 10, 101
say-all();

