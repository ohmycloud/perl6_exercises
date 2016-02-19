#!/home/jon/.rakudobrew/bin/perl6

###
### Hash
###
{
    my %h = (
        one => 'ONE',
        two => 'TWO'
    );
    for %h.kv -> $k, $v {
        say "-$k- -$v-";
    }
    ''.say;

}

###
### Array
###
{
    
    my @arr = <one two three>;
    for @arr.kv -> $i, $v {
        say "{$i+1}) $v";
    }

    ### Or, simply:
    for @arr -> $v {
        say $v;
    }
    ''.say;

}
