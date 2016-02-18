#!/home/jon/.rakudobrew/bin/perl6

while True {
    my $ans = prompt("Enter a number: ");
    redo unless is_a_number($ans);
}
say "foo";


sub is_a_number($a) {
    return True if $a ~~ /^\d+$/;
    return False;
}





GETNUM:
while True {
    my $ans = prompt("Enter a number: ");
    say "--$ans--";
    say is_a_number($ans);
    redo GETNUM unless is_a_number($ans);
}



