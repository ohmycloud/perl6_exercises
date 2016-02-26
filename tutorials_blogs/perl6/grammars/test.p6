#!/home/jon/.rakudobrew/bin/perl6


            grammar TestGrammar {
                token TOP {
                    ^ \d+ $
                }
                token ws { \h+ }
            }

            class TestActions {
                method TOP($match) {
                    $match.make(2 + $match);
                }
            }

                my $match   = TestGrammar.parse('40', actions => TestActions.new);
                say $match;
