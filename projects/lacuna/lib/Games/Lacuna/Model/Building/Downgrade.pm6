
use Games::Lacuna::Model::NonCommModel;

class Games::Lacuna::Model::Building::Downgrade does Games::Lacuna::Model::NonCommModel {
    has Bool $.can;
    has Str $.because; 
    has Str $.image;
    ### The server uses the word 'reason' instead of 'because'.  But Upgrade 
    ### also has a 'reason' attribute, and it's a class, not a string, where 
    ### here we only get a string.  So I'm changing the name to avoid 
    ### confusion.  Hopefully.
    method can      { return $!can if defined $!can or not defined %.json<can>; $!can = %.json<can>.Int.Bool; }
    method because  { return $!because if defined $!because or not defined %.json<reason>; $!because = %.json<reason>; }
    method image    { return $!image if defined $!image or not defined %.json<image>; $!image = %.json<image>; }
    submethod BUILD (:%!json) { }
}

