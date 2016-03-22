
use Config::Simple;
use JSON::Tiny;
use Net::HTTP::GET;
use Net::HTTP::POST;
use URI;

=for comment
    Produce HTML with:
        perl6 -I ../.. --doc=HTML Account.pm > Account.html
    But the formatting of the HTML output is (currently) just awful.

use Games::Lacuna::Comms;
use Games::Lacuna::Exception;


#| TLE Account, handles authenticating with the server
class Games::Lacuna::Account does Games::Lacuna::Comms {
    has Str $.endpoint_name;
    has Str $.user;
    has Str $.pass;
    has Str $.api_key;
    has Str $.server;
    has Str $.session_id;
    has Str $.config_section;
    has IO::Path $.base_dir;
    has IO::Path $.config_file;

    has Str $.empire_name;
    has Int $.empire_id;
    has Int $.alliance_id;

    ### Each of these is
    ###  {
    ###     <ids>{$body_id}       = $body_name
    ###     <names>{$body_name}   = $body_id
    ###  }
    has Hash %.mycolonies;
    has Hash %.mystations;
    has Hash %.ourstations;

    #|{
        Constructor
        You can pass in all options if you like, but you're more frequently 
        going to just pass in a config file section name and let the 
        constructor read your credentials from that.
 
        The config file is assumed to live in $base_dir/config/lacuna.cfg, so 
        'base_dir' is always required.
 
        Even if you're passing the credentials, you can still pass in a config 
        file section name.  If that section exists in the config file, its 
        creds will override what you'd passed in.
        If the section didn't already exist, the creds you passed in will be 
        saved to a new section.
        If you don't pass in a section name, it'll default to 'real'.
 
        So while you can do this:
            my $a = Games::Lacuna::Account.new( :$base_dir, :$server, :$user, :$pass, :$config_section );
            my $a = Games::Lacuna::Account.new( :$base_dir, :$server, :$user, :$pass );

        This is almost certainly what you want:
            my $a = Games::Lacuna::Account.new( :$base_dir, :$config_section );
    #}
    ### CHECK I'm not convinced I need two new()s here.
    multi method new(:$base_dir!, :$user!, :$pass!, :$server = 'us1', :$config_section = 'real') {#{{{
        my $obj = self.bless(:$server, :$user, :$pass, :$base_dir, :$config_section);
        $obj.config_file();
        $obj.load_config();
        $obj;
    }#}}}
    multi method new(:$base_dir!, :$config_section) {#{{{
        my $obj = self.bless(:$base_dir, :$config_section);
        $obj.config_file();
        $obj.load_config();
        $obj;
    }#}}}
    multi submethod BUILD(:$server!, :$user!, :$pass!, :$base_dir!, :$config_section!) {#{{{
        $!user              = $user;
        $!pass              = $pass;
        $!base_dir          = $base_dir;
        $!server            = $server;
        $!api_key           = q<perl6 test>;
        $!endpoint_name     = q<empire>;
        $!config_section    = $config_section;
    }#}}}
    multi submethod BUILD(:$base_dir!, :$config_section!) {#{{{
        $!base_dir          = $base_dir;
        $!api_key           = q<perl6 test>;
        $!endpoint_name     = q<empire>;
        $!config_section    = $config_section;
    }#}}}

    #|{
        Sets the config file as an IO::Path object and returns it.
        Creates the file if it does not already exist and dies if that 
        creation is not possible.

        With no args passed, assumes that the config file should exist as 
        $.base_dir/config/lacuna.cfg.  Both the file and the config/ directory 
        will be created if needed.

        Also accepts a full (Str) path.  Will create that path and file if 
        needed.
    #}
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
        my $conf = Config::Simple.read($.config_file.Str, :f<ini>);
        if $.config_section ne 'DEFAULT' {
            ### Copy anything this config_section doesn't explicitly set from 
            ### the DEFAULT config_section except for the session_id.
            for <user pass api_key server> -> $a {
                $conf{$.config_section}{$a} ||= $conf<DEFAULT>{$a};
            }
        }
        $!user          = $conf{$.config_section}<user>         || q<>;
        $!pass          = $conf{$.config_section}<pass>         || q<>;
        $!server        = $conf{$.config_section}<server>       || q<>;
        $!api_key       = $conf{$.config_section}<api_key>      || q<>;
        $!session_id    = $conf{$.config_section}<session_id>   || q<>;
    }#}}}
    method save_config() {#{{{
        my $conf = Config::Simple.read($!config_file.Str, :f<ini>);
        $conf{$.config_section}<user>       = $!user;
        $conf{$.config_section}<pass>       = $!pass;
        $conf{$.config_section}<server>     = $!server;
        $conf{$.config_section}<api_key>    = $!api_key;
        ### If we don't have a $!session_id we're not logged in (we probably 
        ### just called logout), so delete the key entirely.
        $conf{$.config_section}<session_id> = $!session_id or $conf{$.config_section}<session_id>:delete;
        $conf.write;
    }#}}}

    #|{
        Send a simple request using $!session_id.  If the request goes 
        through, our session_id is still good and we return True.
        Otherwise return False.
    #}
    method test_session() { ### #{{{
        return False unless $!session_id;
        my $rv = $.send( :$!endpoint_name, :method('get_status'), [$!session_id], :opts(id => 42));
        return $rv if $rv<id> eqv 42 and not $rv<error>;
        return False;
    }#}}}


    #|{
        If we've already got a session_id attribute set, this tests that ID. 
        If it's valid, this just sets our logged-in attributes and returns 
        without calling the server's login() method.
        If the session_id is no good or we don't have one, this logs in and 
        gets a valid one for us.
        Throws exception on any failure (eg bad password or server down).
        Sets some attributes and saves them to the config file (including the 
        new session_id) on success.
    #}
    method login( Bool :$skip_test = False ) {#{{{
        unless $skip_test {
            if my $rv = $.test_session {
                ### If our session_id was saved in the config file from a 
                ### previous run, it's already been set as $!session_id, but 
                ### these other attributes have not.
                $.set_attributes( $rv<result><empire> );
                return;
            }
        }

        ### For testing.  Actually, I need to implement some logging facility 
        ### and log this.
        say "no valid session found.  Logging in fresh.";

        my $rv = $.send(
            :$!endpoint_name, :method('login'),
            ($!user, $!pass, $!api_key)
        );
        die Games::Lacuna::Exception.new($rv) if $rv<error>;
        try {
            $!session_id    = $rv<result><session_id>;
            $.set_attributes( $rv<result><status><empire> );
        };
        $.save_config();
    }#}}}

    #|{
        Depending on how we logged in, the empire_hash can be in a few 
        different places in the server response.
        Wherever it was, send it here to set logged-in-specific attributes.
    #}
    method set_attributes (%empire_hash) {#{{{
        $!empire_name   = %empire_hash<name>;
        $!empire_id     = %empire_hash<id>.Int;
        $!alliance_id   = %empire_hash<alliance_id>.Int;

        ### These for loops work.
        for %empire_hash<bodies><colonies>.values -> $c {
            %.mycolonies<ids>{$c<id>}       = $c<name>;
            %.mycolonies<names>{$c<name>}   = $c<id>;
        }
        for %empire_hash<bodies><mystations>.values -> $m {
            %.mystations<ids>{$m<id>}       = $m<name>;
            %.mystations<names>{$m<name>}   = $m<id>;
        }
        for %empire_hash<bodies><ourstations>.values -> $o {
            %.ourstations<ids>{$o<id>}       = $o<name>;
            %.ourstations<names>{$o<name>}   = $o<id>;
        }

        ### The first two maps work.  But the third does not.  However I 
        ### change their order around, the third one doesn't hit.
        #%empire_hash<bodies><colonies>.values.map(    -> $c { %.mycolonies{$c<id>}      = 1 });
        #%empire_hash<bodies><mystations>.values.map(  -> $m { %.mystations{$m<id>}      = 1 });
        #%empire_hash<bodies><ourstations>.values.map( -> $o { %.ourstations{$o<id>}     = 1 });
    }#}}}

    #|{
        Deletes the current user-related attributes from the current Account 
        object. This includes the session_id.  Re-writes the config file to 
        remove the session_id key.
        DOES NOT actually call the server's logout() method, so the session_id 
        is still valid until the server times it out.
    #}
    method logout() {#{{{
        $!empire_name   = Nil;
        $!empire_id     = Nil;
        $!alliance_id   = Nil;
        $!session_id    = Nil;
        %!mycolonies    = ();
        %!mystations    = ();
        %!ourstations   = ();
        $.save_config();
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

