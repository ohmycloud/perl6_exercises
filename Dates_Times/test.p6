#!/home/jon/.rakudobrew/bin/perl6


            my $dt1 = DateTime.new( :year(1969), :month(9), :day(5) );
            my $dt2 = DateTime.new( :year(1972), :month(6), :day(2) );

            my $delta =  $dt2.Instant - $dt1.Instant;
            say $delta;         # 86486400
            say $delta.WHAT;
            
