#!/usr/bin/env perl6

use Terminal::Readsecret;

my $pw1 = getsecret("Type your password: ");
say "-$pw1-";


### If you set a timeout and then the user lets the prompt sit there for more 
### than the set number of seconds, you end up with an exception, including 
### trace, which displays to the user and is ugly.
my timespec $timeout .= new(tv_sec => 5, tv_nsec => 0);     # set timeout to 5 secs
my $pw2 = getsecret("Type your password: ", $timeout);
say "-$pw2-";


### The point of this sort of module is to provide some peace of mind to the 
### muggle user, so the error trace that appears if the timeout is exceeded is 
### not acceptable.
{
    my timespec $timeout .= new(tv_sec => 2, tv_nsec => 0);     # set timeout to 2 secs
    my $pw2 = getsecret("Type your password: ", $timeout);
    say "-$pw2-";
    say $pw2.WHAT;

    CATCH {
        when X::AdHoc {
            ### Exceeding the timeout does produce just an AdHoc exception.  A 
            ### specific X::TOExceeded or some such would be nice, but that's 
            ### not happening.
            say "Timeout exceeded.  Please try again with more of the fastness.";

            ### We do need to exit to avoid getting the trace displayed.  If 
            ### we wanted to continue to the outer scope instead (which would 
            ### hit the "still here" below), replace the exit with ".resume".
            exit;
        }
        default {
            say "shit blew up."; exit;
        }
    }
}

say "still here";

