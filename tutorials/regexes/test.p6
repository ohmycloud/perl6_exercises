#!/home/jon/.rakudobrew/bin/perl6

my $str = 'bar';
#if $str ~~ / $<mystr> = (foo) || $<mystr> = (bar) / {
            if $str ~~ / $<mystr> = (foo || bar) / {
    say "Match";
    say $<mystr>;
}





