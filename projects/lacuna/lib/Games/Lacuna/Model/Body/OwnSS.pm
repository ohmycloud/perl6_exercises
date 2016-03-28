


class Games::Lacuna::Model::Body::OwnSS {}




=begin pod


use Games::Lacuna::Model::Body::OwnBodyRole;
use Games::Lacuna::Model::Body::SSRole;

class Games::Lacuna::Model::Body::OwnSS does Games::Lacuna::Model::Body::OwnBodyRole does Games::Lacuna::Model::Body::SSRole  {
    use Games::Lacuna::Exception;

    submethod BUILD (:$account, :$body_id) {
        $!account       = $account;
        $!endpoint_name = 'body';
        my %rv          = $!account.send(
            :$!endpoint_name, :method('get_status'),
            ($!account.session_id, $body_id)
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><body>;
    }
}


=end pod



 # vim: syntax=perl6 fdm=marker

