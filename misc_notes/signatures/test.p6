#!/home/jon/.rakudobrew/bin/perl6



            sub greet(Str $fname, Str $lname, Int $age = 20) returns Str {
                "Hi, $fname."
            }
            say &greet.signature.arity;
            say &greet.signature.params[0];
            say &greet.signature.params[1];
            say &greet.signature.params[2];
''.say;

            say &greet.signature.params[0].name;    # Str $fname
            say &greet.signature.params[0].type;    # (Str)
            say &greet.signature.params[0].sigil;   # $
