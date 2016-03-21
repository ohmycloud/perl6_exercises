#!/usr/bin/env perl6

use Net::HTTP::GET;
use Net::HTTP::POST;


use lib '.';
use OpenSSL;



if False {   # Works; https.# {{{

    my $url = 'https://doc.perl6.org/language.html';
    my $resp = Net::HTTP::GET($url);
    say $resp.content;
    
}# }}}
if False {   # Works; https.# {{{

    my $url = 'https://github.com/perl6/perl6-lwp-simple';
    my $resp = Net::HTTP::GET($url);
    say $resp.content;
    
}# }}}
if False {   # Works; https.# {{{

    my $url = 'http://rosettacode.org/wiki/24_game/Solve';
    my $resp = Net::HTTP::GET($url);
    say $resp.content;
    
}# }}}
if False {   # Works; https.# {{{

    my $url = 'http://rosettacode.org/wiki/24_game/Solve';
    my $resp = Net::HTTP::GET($url);
    say $resp.content;
    
}# }}}
if True {   # https.  TLE Captcha image.  Only works with my hacked OpenSSL module.  # {{{

    
    ### There's a problem using the default OpenSSL module with either of the 
    ### us1 or pt lacunaexpanse domains.  You can see this error by:
    ###     - Rename ./OpenSSL.pm to any other filename
    ###     - Delete ./out.png
    ###     - Run this as:
    ###         ./test.p6 2>err.txt
    ### 
    ###
    ### When you're satisfied that that blows up, move your temp file back to 
    ### ./OpenSSL.pm again, then run this again.  You don't need to redirect 
    ### STDERR for this run.
    ###     This is grabbing a captcha image from pt.lacunaexpanse.com.  It 
    ###     wouldn't surprise me if those captcha images periodically get 
    ###     wiped.  So test the $url below in your browser first.  If it 
    ###     doesn't show an image, get a fresh URL from my lacuna client code.
    ### 
    ### After running, open ./out.png (which you're 100% sure that the script 
    ### just now created since you deleted it earlier).
    ###
    ###
    ###
    ### Explanation:
    ### ./OpenSSL.pm (at line 37) is testing the passed-in $version number, 
    ### and finding that it's "-1", so the given/when default block is 
    ### hitting.  That's setting the $method to the TLS_v1_2_client_method(), 
    ### which just does not work.
    ###
    ### I copied line 45 down to line 57, overwriting whatever the given/when 
    ### had assigned to $method.  My hardcoding of the $method to 
    ### TLS_v1_client_method() _does_ work.
    ### 
    ###
    ###
    ### I'm not familiar enough with SSL/TLS to be 100% sure what's happening 
    ### here, but I'd guess that the TLE servers' TLS settings are either 
    ### somehow misconfigured or just older than OpenSSL.pm is expecting.




    my $url = 'https://pt.lacunaexpanse.com/captcha/e6/e6685bc8-6e89-4a97-a377-967786a30569.png';
    my $resp = Net::HTTP::GET($url);

    say "about to spurt";
    spurt 'out.png', $resp.body, :bin;
    say "done";

}# }}}

# $ openssl s_client -debug -connect https://pt.lacunaexpanse.com/:443


