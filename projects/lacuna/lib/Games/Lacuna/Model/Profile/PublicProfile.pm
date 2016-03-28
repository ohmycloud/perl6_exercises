
use Games::Lacuna::Model::Profile::ProfileRole;

#|{
    The publicly-viewable portion of a player's profile.
            my $p = Games::Lacuna::Model::PublicProfile.new( :account($a), :empire_id(12345) );
#}
class Games::Lacuna::Model::Profile::PublicProfile does Games::Lacuna::Model::Profile::ProfileRole {#{{{
    use Games::Lacuna::Exception;

    submethod BUILD (:$account, :$empire_id) {
        $!account       = $account;
        $!endpoint_name = 'empire';
        my %rv          = $!account.send(
            :$!endpoint_name, :method('view_public_profile'),
            [$!account.session_id, $empire_id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        %!json = %rv<result><profile>;
    }
}#}}}

 # vim: syntax=perl6 fdm=marker

