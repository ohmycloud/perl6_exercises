
use JSON::Tiny;
use Net::HTTP::GET;
use Net::HTTP::POST;
use URI;

=for comment
    When I try to dump this module out to html by
        perl6 --doc=HTML Lacuna.pm
    it's unable to find G::L::Exception without a 'use lib' to ../../lib/.
    When I do add that in there, I'm getting a compile error.  The bugtracker seems to indicate
    that this bug has been fixed, but for now, when you want to dump out the HTML, just comment
    out the use of GL::Exception.

use Games::Lacuna::Exception;


#| Communicates with TLE servers.
class Games::Lacuna::Comms {#{{{
    has Str $.protocol      = 'http';
    has URI $.endpoint_url; 

    #|{
        Sends data, either positional or named arguments, to a specific TLE endpoint.
        TBD - The first send multimethod, accepting named args, is untested.
    }
    multi method send(Str :$endpoint_name!, Str :$method!, *%named, :%opts) {
        $.set_endpoint_url( $endpoint_name );
        $.send_packet( $.json_rpcize($method, %named, :id(%opts<id> || 1)) );
    }
    multi method send(@pos, Str :$endpoint_name!, Str :$method!, :%opts) {
        $.set_endpoint_url( $endpoint_name );
        $.send_packet( $.json_rpcize($method, @pos, :id(%opts<id> || 1)) );
    }

    #|{
        Accepts a JSON-encoded string, passes it to the currently-set endpoint, 
        decodes and returns the response.
        Throws Games::Lacuna::Broke if the response from the server is not JSON. 
    }
    method send_packet(Str $json_packet) {
        ### $!endpoint_url is a URI object, but NH::POST only accepts strings. 
        ### So stringify $!endpoint_url.
        my $resp    = Net::HTTP::POST("$!endpoint_url", :body($json_packet));
        my $json    = $resp.content(:force);   # :force is required to decode the HTTP response.
        my $rv      = try { from-json($json) };
        die Games::Lacuna::Broke.new( :resp($json) ) if $!;
        return $rv;
    }


    #|{
        Accepts a method name, positional or named arguments, and an optional
        named 'id' argument.  Returns that data as a JSON-encoded string as 
        expected by TLE servers.
    }
    multi method json_rpcize(Str $method, @pos, Int :$id = 1) {
        to-json({ :jsonrpc('2.0'), :id($id), :method($method), :params(@pos) });
    }
    multi method json_rpcize(Str $method, %named, Int :$id = 1) {
        to-json({ :jsonrpc('2.0'), :id($id), :method($method), :params(%named) });
    }


    #|{
        Sets the full endpoint URL, taking into account the protocol, server, and
        final endpoint name.
    }
    multi method set_endpoint_url() {
        return $!endpoint_url if $!endpoint_url and $!endpoint_url ~~ /^ http /;
        $!endpoint_url = $.endpoint_base();
    }
    multi method set_endpoint_url(Str $path) {
        $!endpoint_url = URI.new( ($.endpoint_base(), $path).join('/') );
    }

    #|{
        Returns the endpoint base URL, which will vary depending upon what protocol
        and server we're trying to hit.
    }
    method endpoint_base() {
        URI.new( ("$!protocol://$.server", 'lacunaexpanse', 'com').join('.') );
    }
}#}}}

#| TLE Account, handles authenticating with the server
class Games::Lacuna::Account is Games::Lacuna::Comms {#{{{
    has Str $!endpoint_name = 'empire';
    has Str $.user;
    has Str $.pass;
    has Str $.api_key       = 'perl6_test';
    has Str $.server        = 'us1';
    has Str $.session_id;

    #|{
        Logs in to the server.
        Throws exception on failure.
        Sets self.session_id and returns that session_id on success.
    }
    method login() {
        my $rv = $.send(
            :$!endpoint_name, :method('login'),
            ($!user, $!pass, $!api_key)
        );
        die Games::Lacuna::Exception.new($rv) if $rv<error>;
        try { $!session_id = $rv<result><session_id> };
    }

    #| This does not work yet because of the SSL problem.
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

}#}}}

 # vim: syntax=perl6 fdm=marker

