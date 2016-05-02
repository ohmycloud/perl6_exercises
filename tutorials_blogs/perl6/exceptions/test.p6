#!/home/jon/.rakudobrew/bin/perl6

my Str $name;
try {
    $name = 123;            # 123 is not a Str, so this will blow up.
    say "Hello " ~ $name;

    CATCH {
        when X::AdHoc { say "your code died." }
        default {
            say "Name must be a string";
        }
    }
}
''.say;

try {
    X::AdHoc.new(payload => "blargle").throw;
    CATCH {
        when X::AdHoc { say "your code died." }
    }
}
''.say;

{
    X::IO::DoesNotExist.new(:path("foo/bar"), :trying("zombie copy")).throw;
    CATCH {
        when X::IO      { say "We got an IO exception."; }
        when X::OS      { say "We got an OS exception."; }
        when X::AdHoc   { say "We got an AdHoc exception (die)."; }
        default         { say "we got an exceptional exception." }
    }
}
say "back to main"
