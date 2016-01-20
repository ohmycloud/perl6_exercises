#!/home/jon/.rakudobrew/bin/perl6


my $thingy = 'abcdefg' ~~ / deq /;
say $thingy;
say $thingy.WHAT;
say $thingy.prematch;
''.say;

            if 'abcdefg' ~~ / de / {
                say $/;                 # ｢de｣
                say ~$/;                # de
                say $/.prematch;        # abc
                say $/.postmatch;       # fg
                say $/.from;            # 3
                say $/.to;              # 5
            }
