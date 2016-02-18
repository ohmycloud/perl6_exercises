#!/home/jon/.rakudobrew/bin/perl6

class MyClass {
    method x { "this is user-defined method 'x'." }
}

my $c = MyClass.new;

say $c.WHAT;            # (MyClass)
say $c.WHO;             # MyClass
say $c.WHERE;           # 139830765374168   (memory location?)
say $c.HOW;             # Perl6::Metamodel::ClassHOW.new
say $c.WHY;             # (Any)
say $c.DEFINITE;        # True
say $c.VAR;             # MyClass.new
''.say;

### WHICH appears to give a unique ID to different objects of the same class.  
### These numbers change on each run, but multiple accesses to the same 
### object's WHICH in the same run do return the same ID:
my $other = MyClass.new;
say $c.WHICH;           # MyClass|75565616
say $c.WHICH;           # MyClass|75565616
say $other.WHICH;       # MyClass|75565680

''.say;


.say for (1, 2, 3); # not itemized, so "1\n2\n3\n"
.say for [1, 2, 3]; # itemized, so "1 2 3\n"
say (1, 2, 3).VAR ~~ Scalar; # False
say [1, 2, 3].VAR ~~ Scalar; # True


