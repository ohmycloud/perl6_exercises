
use JSON::Tiny;
use Net::HTTP::GET;
use Net::HTTP::POST;
use URI;

use Games::Lacuna::Exception;

=begin pod

=head1 COMMUNICATIONS FLOW
Session IDs expire every $time_period.  I think it's 2 hours now, and there's 
been talk of Icy changing that to 4 hours, but either way, it will expire 
eventually.

Models that need to talk to the server do the Comms role, so they could call 
self.send() to send data to the server.  However, if you call send() 
specifically on a GL::Account object, that send() call will automatically 
attempt to re-login if it discovers that the session ID has expired.  Since 
any model that does the Comms role also does the Model role, those models 
I<will> have $.account attributes pointing at GL::Account objects.

So, eg if you're working in the Profile module, instead of calling:
 %!json_parsed   = self.send(
  :$!endpoint_name, :method('view_profile'),
  [$!account.session_id]
 );

You should prefer to make that same call on the Profile's $.account attribute:
 %!json_parsed   = $.account.send(
  :$!endpoint_name, :method('view_profile'),
  [$!account.session_id]
 );

The logic flow is:
    - Profile class uses its $.account attribute to send a request to the 
      view_profile() TLE method
        - So Profile is calling $.account.send(), which in turn calls 
          Comms::send().
    - Comms::send() sends the request and checks the response, noting that it 
      contains an error stating that the session ID has expired.
        - Comms::send() also notes that the calling object is an Account 
          object.
        - So Comms::send() re-calls login() on that Account object.
    - Now that we're re-logged in, our account object's $.session_id is valid, 
      so we can re-try the original view_profile() call that failed.
    - However, we're still holding the original arguments array sent to 
      view_profile(), and that array contains the old (bad) session id.  We 
      need to replace that old session_id with our new one.
        - Since we're using positional params in this case, we can't know for 
          sure (programmatically) where in the @args array that session_id is.
        - As it happens, in TLE's positional-arg methods, the session_id 
          always comes first, so we'll replace @args[0] with our new, valid 
          session_id.
    - Now we can call view_profile() again, passing our modified @args array, 
      and return the result of that.

All of the above happens automatically, as long as you're calling send() from 
a GL::Account object.

=end pod



role Games::Lacuna::Comms {
    has Str $.protocol      = 'http';
    has URI $.endpoint_url; 

    #|{
        Sends data, either positional or named arguments, to a specific TLE endpoint.

        TBD - The first send multimethod, accepting named args, is untested. 
        When you get to dealing with TLE methods that use named args, have 
        that named arg send() below end up looking much like the positional 
        version.
    }
    multi method send(%named, Str :$endpoint_name!, Str :$method!, :%opts) {#{{{
        $.set_endpoint_url( $endpoint_name );
        my $rv = $.send_packet( $.json_rpcize($method, %named, :id(%opts<id> || 1)) );
    }#}}}
    multi method send(@pos, Str :$endpoint_name!, Str :$method!, :%opts) {#{{{
        $.set_endpoint_url( $endpoint_name );

        my $p1 = start $.send_packet( $.json_rpcize($method, @pos, :id(%opts<id> || 1)) );
        my $rv = await $p1;

        if self.WHAT.perl ~~ 'Games::Lacuna::Account' and $.relogin_expired($rv)  {
            @pos[0] = $.session_id;
            my $p2 = start $.send_packet( $.json_rpcize($method, @pos, :id(%opts<id> || 1)) );
            $rv = await $p2;
        }
        $rv;
    }#}}}
    multi method send(Str :$endpoint_name!, Str :$method!, :%opts) {#{{{
        ### No args, eg the /empire endpoint's fetch_captcha()
        $.set_endpoint_url( $endpoint_name );
        my $rv = $.send_packet( $.json_rpcize($method, :id(%opts<id> || 1)) );
    }#}}}


    #|{
        If the server response is an expiration error, we'll try to re-login.
        Returns True if a re-login was necessary.  In which case our 
        $.session_id will have been reset to a valid session ID.
        If no re-login was necessary, returns False.
    #}
    method relogin_expired($resp --> Bool) {#{{{
        if $resp<error><code> eqv 1006 and $resp<error><message> eqv 'Session expired.' {
            self.login(:skip_test(True));
            return True;
        }
        return False;
    }#}}}

    #|{
        Calls Net::HTTP::GET on a url and returns the response.
    }
    multi method http_get(Str $url --> Net::HTTP::Response) {#{{{
        return Net::HTTP::GET( $url );
    }#}}}
    multi method http_get(URI $url --> Net::HTTP::Response) {#{{{
        return Net::HTTP::GET( "$url" );
    }#}}}

    #|{
        Accepts a JSON-encoded string, passes it to the currently-set 
        TLE endpoint, decodes and returns the response.
        Throws Games::Lacuna::Broke if the response from the server is not 
        JSON.
    }
    method send_packet(Str $json_packet) {#{{{
        ### $!endpoint_url is a URI object, but NH::POST only accepts strings. 
        ### So stringify $!endpoint_url.
        my $resp    = Net::HTTP::POST("$!endpoint_url", :body($json_packet));
        my $json    = $resp.content(:force);   # :force is required to decode the HTTP response.
        my $rv      = try { from-json($json) };
        die Games::Lacuna::Broke.new( :resp($json) ) if $!;
        return $rv;
    }#}}}

    #|{
        Accepts a method name, positional or named arguments, and an optional
        named 'id' argument.  Returns that data as a JSON-encoded string as 
        expected by TLE servers.
    }
    multi method json_rpcize(Str $method, %named, Int :$id = 1) {#{{{
        to-json({ :jsonrpc('2.0'), :id($id), :method($method), :params(%named) });
    }#}}}
    multi method json_rpcize(Str $method, @pos, Int :$id = 1) {#{{{
        to-json({ :jsonrpc('2.0'), :id($id), :method($method), :params(@pos) });
    }#}}}
    multi method json_rpcize(Str $method, Int :$id = 1) {#{{{
        to-json({ :jsonrpc('2.0'), :id($id), :method($method) });
    }#}}}

    #|{
        Sets the full endpoint URL, taking into account the protocol, server, and
        final endpoint name.
    }
    multi method set_endpoint_url() {#{{{
        return $!endpoint_url if $!endpoint_url and $!endpoint_url ~~ /^ http /;
        $!endpoint_url = $.endpoint_base();
    }#}}}
    multi method set_endpoint_url(Str $path) {#{{{
        $!endpoint_url = URI.new( ($.endpoint_base(), $path).join('/') );
    }#}}}

    #|{
        Returns the endpoint base URL, which will vary depending upon what protocol
        and server we're trying to hit.
    }
    method endpoint_base() {#{{{
        URI.new( ("$!protocol://$.server", 'lacunaexpanse', 'com').join('.') );
    }#}}}
}

 # vim: syntax=perl6 fdm=marker

