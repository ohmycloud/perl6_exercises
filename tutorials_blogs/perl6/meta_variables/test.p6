#!/home/jon/.rakudobrew/bin/perl6


my $num = 4;
my $str = 'foobar';

say $num.^name;     # Int
say $str.^name;     # Str

say $num.WHAT;     # (Int)
say $str.WHAT;     # (Str)

say $num.perl;     # 4
say $str.perl;     # "foobar"       (the quotes do get displayed)

say $num.gist;     # 4
say $str.gist;     # foobar         (the quotes do NOT get displayed)

