#!/home/jon/.rakudobrew/bin/perl6

            my $str = "The quick brown fox";
            say so $str ~~ / << quic /;             # True
            say so $str ~~ / quic >> /;             # False
