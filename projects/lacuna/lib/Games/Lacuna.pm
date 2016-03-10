
use JSON::Tiny;
use Net::HTTP::GET;
use Net::HTTP::POST;

class Games::Lacuna::Comms {
    has Str $.protocol      = 'http';
    has Str $.endpoint_url; 

    ### There _is_ a URI p6 module out there.  $endpoint_url should really be 
    ### of that class rather than a Str.
    ###
    ###
    ### I want to end up not using *%named as a slurpy param.  I should be 
    ### able to drop the * and move the arg to the front of the signature. 
    ### See the second multi method where that's working for @pos.

    multi method send(Str :$endpoint_name!, Str :$method!, *%named) {
        $.set_endpoint_url( $endpoint_name );
        $.send_packet( $.json_rpcize($method, %named) );
    }
    multi method send(@pos, Str :$endpoint_name!, Str :$method!) {
        $.set_endpoint_url( $endpoint_name );
        $.send_packet( $.json_rpcize($method, @pos) );
    }

    method send_packet(Str $json_packet) {
        my $resp = Net::HTTP::POST($!endpoint_url, :body($json_packet));
        from-json( $resp.content(:force) ); # :force is required to decode the HTTP response.
    }


    ### On IDs -- I'd like for these methods to allow an optional ID argument 
    ### and send either that or '1'.
    multi method json_rpcize(Str $method, @pos) {
        to-json({ :jsonrpc('2.0'), :id(1), :method($method), :params(@pos) });
    }
    multi method json_rpcize(Str $method, %named) {
        to-json({ :jsonrpc('2.0'), :id(1), :method($method), :params(%named) });
    }


    multi method set_endpoint_url() {
        return $!endpoint_url if $!endpoint_url and $!endpoint_url ~~ /^ http /;
        $!endpoint_url = $.endpoint_base();
    }
    multi method set_endpoint_url(Str $path) {
        $!endpoint_url = ($.endpoint_base(), $path).join('/');
    }
    method endpoint_base() {
        ("$!protocol://$.server", 'lacunaexpanse', 'com').join('.');
    }
}

class Games::Lacuna::Account is Games::Lacuna::Comms is export {
    has Str $!endpoint_name = 'empire';
    has Str $.user;
    has Str $.pass;
    has Str $.api_key       = 'perl6_test';
    has Str $.server        = 'us1';
    has Str $.session_id;

    method login() {
        my %rv = $.send( :$!endpoint_name, :method('login'), ($!user, $!pass, $!api_key) );
        $!session_id = %rv<result><session_id>;
    }

    method fetch_captcha() {#{{{
        my %rv = $.send(:$!endpoint_name, :method('fetch_captcha') );

        ### If you try this again, I suggest you do
        ###     ./script.p6 2> err.txt
        ### because it produced a shitton of output on STDERR but only a 
        ### couple lines on STDOUT the last time it blew up.
        ###
        ### The problem might be IO::Socket::SSL, and it might be 
        ### Net::HTTP::GET; I dunno.  Might be worth seeing if there's another 
        ### HTTP client out there and give that a shot.
        ###
        #my $resp = Net::HTTP::GET( %rv<result><url> );
        #spurt 'test.png', $resp.content(:force);

        say "The URL for the captcha is %rv<result><url>";
        say "but perl6 seems unable to grab that at this time.";
        say "The previous message was hard-coded 03/09/2016, so check again.";
    }#}}}

}


