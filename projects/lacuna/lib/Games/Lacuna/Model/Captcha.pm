
=begin pod

=head1 SYNOPSIS

 my $c = Games::Lacuna::Model::Captcha.new( :account($a) );
 $c.fetch;
 $c.save('somefile.png');
 shell("xdg-open somefile.png");     # or whatever makes sense on your OS
 print "I just displayed a captcha image.  Enter the solution here: ";
 my $resp = $*IN.get();
 'somefile.png'.IO.unlink;

 say $c.solve($resp) ?? "Correct!" !! "BRRRRZZZT!";

=end pod


class Games::Lacuna::Model::Captcha {
    use Games::Lacuna::Model::Captcha::LoggedInCaptcha;
    use Games::Lacuna::Model::Captcha::NewUserCaptcha;

    multi method new(:$account!) {
        return Games::Lacuna::Model::Captcha::LoggedInCaptcha.new(:$account);
    }
    multi method new() {
        return Games::Lacuna::Model::Captcha::NewUserCaptcha.new();
    }
}



 # vim: syntax=perl6 fdm=marker

