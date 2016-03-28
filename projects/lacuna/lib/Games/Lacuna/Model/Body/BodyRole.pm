
role Games::Lacuna::Model::Body::BodyRole {
    use Games::Lacuna::Model::Body::UtilSS;

    has Int $.id;
    has Int $.x;
    has Int $.y;
    has Int $.star_id;
    has Int $.orbit;
    has Int $.size;
    has Int $.water;
    has Str $.star_name;
    has Str $.type;
    has Str $.name;
    has Str $.image;

    has Int %.ore;
    has Games::Lacuna::Model::Body::UtilSS $.station;          # Only set if the body is under SS control

    method id           { return $!id if defined $!id or not defined %.json<id>; $!id = %.json<id>.Int; }
    method x            { return $!x if defined $!x or not defined %.json<x>; $!x = %.json<x>.Int; }
    method y            { return $!y if defined $!y or not defined %.json<y>; $!y = %.json<y>.Int; }
    method star_id      { return $!star_id if defined $!star_id or not defined %.json<star_id>; $!star_id = %.json<star_id>.Int; }
    method orbit        { return $!orbit if defined $!orbit or not defined %.json<orbit>; $!orbit = %.json<orbit>.Int; }
    method size         { return $!size if defined $!size or not defined %.json<size>; $!size = %.json<size>.Int; }
    method water        { return $!water if defined $!water or not defined %.json<water>; $!water = %.json<water>.Int; }
    method star_name    { return $!star_name if defined $!star_name or not defined %.json<star_name>; $!star_name = %.json<star_name>; }
    method type         { return $!type if defined $!type or not defined %.json<type>; $!type = %.json<type>; }
    method name         { return $!name if defined $!name or not defined %.json<name>; $!name = %.json<name>; }
    method image        { return $!image if defined $!image or not defined %.json<image>; $!image = %.json<image>; }
    method ore          { return %!ore if %!ore.keys.elems > 0 or not defined %.json<ore>; %!ore = %.json<ore>; }


    ### I wanted to do this:
        #method station { return $!station if defined $!station or not defined %.json<station>; $!station = Games::Lacuna::Model::Body.new(:station_hash(%.json<station>)); }
    ###
    ### But at this point, we're in a chicken-and-egg situation, and p6 won't 
    ### let me do that.  The error given is "You cannot create an instance of 
    ### this type".
    ###
    ### The problem looks like it has to do with lexical ordering, and just 
    ### moving roles and classes around in here might work (I haven't looked 
    ### into it enough to see if it's possible), but would be really fragile.
    ###
    ### So instead, I created the UtilSS class which doesn't depend on 
    ### anything.  I'd have preferred not to have to do that, but am not 
    ### seeing any other solutions, and this does work just fine.
    method station { return $!station if defined $!station or not defined %.json<station>; $!station = Games::Lacuna::Model::Body::UtilSS.new(:station_hash(%.json<station>)); }

}

 # vim: syntax=perl6 fdm=marker

