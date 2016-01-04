#!/home/jon/.rakudobrew/bin/perl6


    try {
        CATCH {
            .Str.say;
            $_.resume;
        }
        die "this is the thing that's going to get caught."
    }
    say "this gets output.";
