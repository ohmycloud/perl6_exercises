#!/usr/bin/env perl6

use Bot::BasicBot:from<Perl5>;

### Bot::BasicBot can't be used on its own.  It's intended to be subclassed.  
### But that's no problem.  Now that we've imported it, we can just use it 
### like any other class.

class P6Bot is Bot::BasicBot {
    # ....bot code goes here....
}


say "if this gets output, nothing above is an error.";

