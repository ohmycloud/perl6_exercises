
use Games::Lacuna::Model;
use Games::Lacuna::Model::Captcha::CaptchaRole;

class Games::Lacuna::Model::Captcha::LoggedInCaptcha does Games::Lacuna::Model::Captcha::CaptchaRole does Games::Lacuna::Model {
    use Games::Lacuna::Exception;
    use URI;

    submethod BUILD (:$account!) {
        $!account       = $account;
        $!endpoint_name = 'captcha';
    }

    #|{
        Fetches a new captcha, setting the guid, image_url, and image_content 
        attributes.
    }
    method fetch() {#{{{
        %!json   = $.account.send(
            :$.endpoint_name, :method('fetch'),
            [$.account.session_id]
        );
        die Games::Lacuna::Exception.new(%.json) if %.json<error>;
        $!guid          = %.json<result><guid>;
        $!image_url     = URI.new( %.json<result><url> );
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
        %!json   = $!account.send(
            :$.endpoint_name, :method('solve'),
            ($.account.session_id, $.guid, $solution)
        );
        $!guid          = Nil;
        $!image_url     = Nil;
        $!image_content = Nil;
        ### The server does not return true or false.  It throws an error if 
        ### the solution is wrong, and returns true if it was correct.
        return False if %!json<error>;
        return True;
    }#}}}
}

