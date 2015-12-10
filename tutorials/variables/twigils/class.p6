#!/home/jon/.rakudobrew/bin/perl6

=begin Foo

. refers to a method
! refers to a class attribute.

=end Foo

class PointOne {
    ### We're declaring x and y as methods of Point.
    #has $.x;
    #has $.y;

    ### Even though they're declared as methods, we can assign them values.
    has $.x = 1;
    has $.y = 2;

    method call_meth() {
        "METH: ($.x, $.y)";
    }

    ### Now, those methods are also attributes, presumably because they were 
    ### declared using 'has'.  
    method call_attr() {
        "ATTR: ($!x, $!y)";
    }
}
my $p1 = PointOne.new();
say $p1.call_meth;
say $p1.call_attr;

### When we declared x and y as methods, they automatically became getters.  
### However, they're immutable, so we can't do this:
#$p1.x(5);
#$p1.x = 5;

say "";




class PointTwo {
    has $.x = 1;
    has $.y = 2;

    ### Since x and y have been declared as methods, we can override the 
    ### built-in getters:
    method x { return "this is x" }
    method y { return "this is y" }
    

    ### However, the original attribute values (1 and 2) are still accessible.
    method call_attr() {
        "ATTR: ($!x, $!y)";
    }

    ### So it looks to me like when you say
    ###     has $.x = 1;
    ### You're not just defining x as a method, you're also defining it as a 
    ### scalar attribute.  I think.
}

my $p2 = PointTwo.new();
say $p2.x;              # this is x
say $p2.y;              # this is y
say $p2.call_attr;      # (1, 2)

