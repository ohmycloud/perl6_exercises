
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


=for comment
    Structure
    This file contains GL::Account, which hits the /empire endpoint.  But I'm 
    considering the GL::Account class to be more bookkeeping-related than 
    game-related.
    The GL::Empire class also hits the /empire endpoint, but it doesn't manage 
    logging in and session IDs, etc -- GL::Empire is game-related.


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
    has Str $!endpoint_name     = 'empire';
    has Str $.user;
    has Str $.pass;
    has Str $.api_key           = 'perl6_test';
    has Str $.server            = 'us1';
    has Str $.session_id;

    has Str $.section is rw     = 'real';
    has IO::Path $.base_dir;
    has IO::Path $.config_file;


    #|{
        Returns the config file as an IO::Path object.
        Creates the file if it does not already exist and dies if that 
        creation is not possible.

        With no args passed, assumes that the config file should exist as 
        $.base_dir/config/lacuna.cfg.  Both the file and the config/ directory 
        will be created if needed.

        Also accepts a full (Str) path.  Will create that path and file if 
        needed.
    }
    proto method config_file(|) {#{{{
        {*};
        my $dir = IO::Path.new( $!config_file.dirname );
        $dir.mkdir or die "$dir: Could not create directory.";
        if $!config_file !~~ :e {   # create the config file if it doesn't already exist.
            my $rv = $!config_file.open(:w);
            $rv.close();
        }
        ### If we just created the file, our $!config_file object was created 
        ### before the file existed.  It has not been updated to understand 
        ### that the file now exists, even though we used its own open() 
        ### method to create the thing.  This is presumably an IO::Handle bug 
        ### that'll get worked out eventually.
        ### For now, we have to re-create $!config_file to get it to re-stat 
        ### the (possibly newly-created) file to tell if the thing is writable 
        ### or not.
        $!config_file = IO::Path.new( $!config_file );
        die "$!config_file Cannot write to file." unless $!config_file ~~ :w;
        return $!config_file;
    }#}}}
    multi method config_file() {#{{{
        $!config_file   = IO::Path.new( $.base_dir.Str ~ '/config/lacuna.cfg' );
    }#}}}
    multi method config_file(Str $path) {#{{{
        $!config_file    = IO::Path.new( $path );
    }#}}}

    method load_config() {#{{{
        my $conf = Config::Simple.read($!config_file.Str, :f<ini>);
        if $!section ne 'DEFAULT' {
            ### Copy anything this section doesn't explicitly set from the 
            ### DEFAULT section except for the session_id.
            for <user pass api_key server> -> $a {
                $conf{$!section}{$a} ||= $conf<DEFAULT>{$a};
            }
        }
        $!user          = $conf{$!section}<user>;
        $!pass          = $conf{$!section}<pass>;
        $!server        = $conf{$!section}<server>;
        $!api_key       = $conf{$!section}<api_key>;
        $!session_id    = $conf{$!section}<session_id>;
    }#}}}
    method save_config() {#{{{
        my $conf = Config::Simple.read($!config_file, :f<ini>);
        $conf{$!section}<user> = $!user;
        $conf{$!section}<pass> = $!pass;
        $conf{$!section}<server> = $!server;
        $conf{$!section}<api_key> = $!api_key;
        $conf{$!section}<session_id> = $!session_id;
        $conf.write;
    }#}}}

    method test_session() {
        ### If we've got a $!session_id, make some call to the server.  If the 
        ### call comes back, our session ID is good.  Otherwise we have to log 
        ### in again.
        ###
        ### Might as well make a useful call (like view_profile) and do 
        ### something with its retval if we get one.
        return False unless $.session_id;
    }







    #|{
        Logs in to the server.
        Throws exception on any failure (eg bad password or server down).
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

