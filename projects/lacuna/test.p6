#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Games::Lacuna;

my $user        = 'tmtowtdi';
my $pass        = 'hi vas';     # THIS IS GETTING CHECKED IN TO GITHUB DON'T USE A REAL PASSWORD HERE
my $server      = 'pt';
my $base_dir    = IO::Path.new( IO::Path.new(callframe(0).file.IO.dirname).absolute );

#`{ Yikes on that $base_dir # {{{

    callframe(0).file.IO
        the IO::Path object representing this file.


    callframe(0).file.IO.dirname
        The directory this file is in, expressed as just '.'
        But it's only a string, not an IO::Path object itself!

        The problem is that I need to get pwd expressed as a full path, not as 
        just '.'.  To do that, I want to call .absolute() on pwd, but need pwd 
        to be an IO::Path object, not a string.

        So I have to pass the string to IO::Path.new().


    (IO::Path object created from dirname above).absolute
        This gives us the /full/path/to/pwd/.
        However, it's JUST A FUCKING STRING AGAIN.

        Once again, we have to pass this to IO::Path.new(), because I want my 
        $base_dir to be an IO::Path object before passing it in to the 
        constructor, which is expecting an IO::Path object. 

}# }}}


### Create account object.  This does not log you in.
###
### Named args, so either version works.
###
### At this point, I'm not seeing any way for module code located in another 
### file to determine the path to this file (there's no FindBin yet).  So for 
### now at least, I'm going to require passing in the $base_dir.
#my $a = Games::Lacuna::Account.new(:$user, :$pass, :$server, :$base_dir);
my $a = Games::Lacuna::Account.new(:$server, :$user, :$pass, :$base_dir);

say $a.config_file;
exit;


### This does log you in.  I'm not saving the session ID anywhere at this 
### point, so each run of this re-logs-in.
$a.login();
say "After logging in, my session ID is: {$a.session_id}";


### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

