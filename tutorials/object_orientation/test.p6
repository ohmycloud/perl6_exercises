#!/home/jon/.rakudobrew/bin/perl6

class Superman {
    method primary_power { return 'strength' }
}
my $s = Superman.new();
my $s1 = Superman.new();
say $s.HOW === $s1.HOW;

''.say;

            say 1.HOW === Int.HOW;      # True
            say 1.HOW === Num.HOW;      # False (false?  wtf?)

''.say;

            my $num_obj     = 1;
            say $num_obj.^name;                     # Int
