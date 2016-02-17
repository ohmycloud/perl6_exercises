#!/home/jon/.rakudobrew/bin/perl6

my @candidate_colors = <red blue green>;

            COLORS:
            for @candidate_colors -> $c {
                next COLORS if $c eq 'green';
                say $c;
            }

            say COLORS.WHAT;

