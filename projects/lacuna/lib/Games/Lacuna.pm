
use Config::Simple;
use JSON::Tiny;
use Net::HTTP::GET;
use Net::HTTP::POST;
use URI;


=for comment
    Left off working on GL::Model




=for comment
    When I try to dump this module out to html by
        perl6 --doc=HTML Lacuna.pm
    it's unable to find G::L::Exception without a 'use lib' to ../../lib/.
    When I do add that in there, I'm getting a Pod compile error.
    The bugtracker seems to indicate that this bug has been fixed, but for 
    now, when you want to dump out the HTML, just comment out all of the use 
    lines below.

use Games::Lacuna::Exception;
use Games::Lacuna::Account;

use Games::Lacuna::Empire;


=for comment
    Structure
    This file contains GL::Account, which hits the /empire endpoint.  But I'm 
    considering the GL::Account class to be more bookkeeping-related than 
    game-related.
    The GL::Empire class also hits the /empire endpoint, but it doesn't manage 
    logging in and session IDs, etc -- GL::Empire is game-related.





 # vim: syntax=perl6 fdm=marker

