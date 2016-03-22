
use URI;
use Games::Lacuna::Exception;
use Games::Lacuna::DateTime;
use Games::Lacuna::Model;

=begin pod

=head1 SYNOPSIS

 my $c = Games::Lacuna::Model::Captcha.new( :account($a) );
 $c.fetch;
 $c.save('somefile.png');
 shell("xdg-open somefile.png");     # obviously not portable but fine for a test script.
 print "I just displayed a captcha image.  Enter the solution here: ";
 my $resp = $*IN.get();
 'somefile.png'.IO.unlink;

 say $c.solve($resp) ?? "Correct!" !! "BRRRRZZZT!";

=end pod

role Games::Lacuna::Model::CaptchaRole {#{{{
    has Str $.guid;
    has URI $.image_url;
    has Buf $.image_content;
}#}}}
class Games::Lacuna::Model::NewUserCaptcha does Games::Lacuna::Model::CaptchaRole does Games::Lacuna::Model::NotLoggedInModel {#{{{
    submethod BUILD () {
        ### The empire endpoint allows for fetching a captcha without a 
        ### session_id.  The user's solution to this captcha is passed along 
        ### to empire::create() when creating a new empire.
        ###
        ### I honestly don't care too much about making this p6 client 
        ### "complete", so ensuring that it can create a new empire is awfully 
        ### low on my priority list, so this class will probably never be 
        ### completed.
    }
}#}}}
class Games::Lacuna::Model::LoggedInCaptcha does Games::Lacuna::Model::CaptchaRole does Games::Lacuna::Model {#{{{

    submethod BUILD (:$account!) {
        $!account       = $account;
        $!endpoint_name = 'captcha';
    }

    #|{
        Fetches a new captcha, setting the guid, image_url, and image_content 
        attributes.
    }
    method fetch() {#{{{
        %!json_parsed   = $.account.send(
            :$.endpoint_name, :method('fetch'),
            [$.account.session_id]
        );
        die Games::Lacuna::Exception.new(%.json_parsed) if %.json_parsed<error>;
        $!guid          = %.json_parsed<result><guid>;
        $!image_url     = URI.new( %.json_parsed<result><url> );
        my $resp        = $.http_get( $.image_url );
        $!image_content = $resp.body;
    }#}}}

    #|{
        Once a captcha has been fetched, its image data is stored in the 
        image_content attribute; you can do with that as you wish.  But you 
        often just want to save that image to a file, which this allows.
    }
    proto method save(|) {#{{{
        $.image_content or die "fetch() must be called before save().";
        {*};
    }#}}}
    multi method save(Str $file) {#{{{
        spurt $file, $.image_content, :bin;
    }#}}}
    multi method save(IO::Path $file) {#{{{
        spurt $file, $.image_content, :bin;
    }#}}}

    #|{
        Attempt to solve the current captcha.
        Returns True or False depending upon whether the solution was correct 
        or not.

        Unsets the guid, image_url, and image_content attributes whether the 
        solution was correct or not (the user only gets one chance to attempt 
        a captcha).  If the solution failed and the user wants to try again, 
        you'll need to re-call fetch().
    }
    method solve(Str $solution --> Bool) {#{{{
        %!json_parsed   = $!account.send(
            :$.endpoint_name, :method('solve'),
            ($.account.session_id, $.guid, $solution)
        );
        $!guid          = Nil;
        $!image_url     = Nil;
        $!image_content = Nil;
        ### The server does not return true or false.  It throws an error if 
        ### the solution is wrong, and returns true if it was correct.
        return False if %!json_parsed<error>;
        return True;
    }#}}}
}#}}}


#|{
    Factory
#}
class Games::Lacuna::Model::Captcha does Games::Lacuna::Model {

    multi method new(:$account!) {#{{{
        return Games::Lacuna::Model::LoggedInCaptcha.new(:$account);
    }#}}}
    multi method new() {#{{{
        return Games::Lacuna::Model::NewUserCaptcha.new();
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

