
#|{
    Profile Factory.

    Returns either a public profile or a private profile.  The private profile 
    can only be returned for the current account, and only when that account 
    has been logged in using its full, not sitter, password.

    Examples:
            my $pub_profile  = Games::Lacuna::Model::Profile.new( :account($a), :empire_id(23598) );
            my $priv_profile = Games::Lacuna::Model::Profile.new( :account($a) );
}
class Games::Lacuna::Model::Profile {
    use Games::Lacuna::Model::Profile::PublicProfile;
    use Games::Lacuna::Model::Profile::PrivateProfile;

    multi method new (:$account!, :$empire_id!) {#{{{
        return Games::Lacuna::Model::Profile::PublicProfile.new(:$account, :$empire_id);
    }#}}}
    multi method new (:$account!) {#{{{
        return Games::Lacuna::Model::Profile::PrivateProfile.new(:$account);
    }#}}}

}



 # vim: syntax=perl6 fdm=marker

