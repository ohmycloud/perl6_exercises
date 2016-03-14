
use JSON::Tiny;
use Net::HTTP::GET;
use Net::HTTP::POST;
use URI;

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



 # vim: syntax=perl6 fdm=marker

