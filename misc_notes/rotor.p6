#!/home/jon/.rakudobrew/bin/perl6

#`(
    .rotor breaks up a list into sub-lists of a requested size.


    The info in here is from:
        http://blogs.perl.org/users/zoffix_znet/2016/01/perl-6-rotor-the-king-of-list-manipulation.html


    There's quite a bit more to that blog post than I've included here; I 
    purposely wanted to just keep the basics in here.  If you need to use 
    rotor(), be sure to read that post.
)



{
    my $new = <a b c d e f>.rotor: 3;
    say $new;

    ### ((a b c) (d e f))
}


### If the original list's size is not divisible by the requested number, any 
### extra elements are dropped, by default:
{
    my $new = <a b c d e f   g h>.rotor: 3;
    say $new;
    ### ((a b c) (d e f))
    ###
    ### ...the g and h got dropped since they're extras.
}


### But you can tell .rotor to include partial groupings:
{
    my $new = <a b c d e f   g h>.rotor: 3, :partial(True);
    say $new;
    ### ((a b c) (d e f) (g h))
    ###
    ### ...the g and h are included now.
    ###
    ### Changing the arg to :partial() to False just puts it back to the 
    ### default behavior.
}


### Although the default behavior of .rotor itself is :partial(False), the 
### default arg to :partial() is True.  So if you include :partial, .rotor() 
### assumes you mean "do something other than the default behavior", which all 
### makes sense.
{
    my $new = <a b c d e f   g h>.rotor: 3, :partial;
    say $new;
    ### ((a b c) (d e f) (g h))
    ###
    ### ...the g and h are included now.
    ###
    ### Changing the arg to :partial() to False just puts it back to the 
    ### default behavior.
}

### Break up a long string into a list (.comb), then break that list up into 
### chunks of 10 (.rotor), without discarding the extras:
{
    my $str = 'abcdefghijklmnopqrstuvwxyz';
    $str.comb.rotor(10, :partial)».join».say;

        ### abcdefghij
        ### klmnopqrst
        ### uvwxyz

}


