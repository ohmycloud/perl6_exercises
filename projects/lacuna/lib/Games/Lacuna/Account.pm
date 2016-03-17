
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
class Games::Lacuna::Account does Games::Lacuna::Comms {#{{{
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
    multi method new(:$base_dir!, :$user!, :$pass!, :$server = 'us1', :$config_section = 'real') {#{{{
        my $obj = self.bless(:$server, :$user, :$pass, :$base_dir, :$config_section);
        $obj.config_file();
        $obj.load_config();
        $obj;
    }#}}}
    multi method new(:$base_dir!, :$config_section) {#{{{
        my $obj = self.bless(:base_dir($base_dir), :config_section($config_section));
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
        If it's no good or we don't have one, this logs in and gets one for 
        us.
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
                $!empire_name   = $rv<result><empire><name>;
                $!empire_id     = $rv<result><empire><id>.Int;
                $!alliance_id   = $rv<result><empire><alliance_id>.Int;
                return;
            }
        }
        my $rv = $.send(
            :$!endpoint_name, :method('login'),
            ($!user, $!pass, $!api_key)
        );

        ### For testing.  Actually, I need to implement some logging facility 
        ### and log this.
        say "no valid session found.  Logging in fresh.";

        die Games::Lacuna::Exception.new($rv) if $rv<error>;
        try {
            $!session_id    = $rv<result><session_id>;
            $!empire_name   = $rv<result><status><empire><name>;
            $!empire_id     = $rv<result><status><empire><id>.Int;
            $!alliance_id   = $rv<result><status><empire><alliance_id>.Int;
        };
        $.save_config();
    }#}}}

    #|{
        Deletes the current user-related attributes (empire_name, _id, 
        alliance_id).  Also deletes session_id and re-writes the config file 
        to remove the session_id key.
        DOES NOT actually call the server's logout() method, so the session_id 
        is still valid until the server times it out.
    #}
    method logout() {#{{{
        $!empire_name   = Nil;
        $!empire_id     = Nil;
        $!alliance_id   = Nil;
        $!session_id    = Nil;
        $.save_config();
    }#}}}

    #| Does not work yet because of the SSL problem.
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

