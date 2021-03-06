#!/home/jon/.rakudobrew/bin/perl6

### http://doc.perl6.org/language/variables#Variable_Declarators_and_Scope


### You already know what these do.
my $my_var;
our $our_var;


### New to p6, but covered already, so you know what these do.
class Jontest {
    has $!attribute;
    has $.method;
}


### constant
###
### Now a formal declarator.
constant $PI = 3.14;



### anon
###
### Prevents a symbol from being installed in the symbol table.  This allows 
### you to create eg anonymous subs that can know their own names.
my $var = anon sub greet($name) { say "Hello, $name." }
$var('Jon');

### So the anon sub does know its own name
say $var.name;  # greet

### But, since we declared it with anon, we can't just call it by the routine 
### name.  Uncommenting this results in
###     Undeclared routine:
###         greet used at line 25. Did you mean 'grep'?
#greet('Fred');
''.say;



### state
### 
### http://doc.perl6.org/language/variables#The_state_Declarator
### This is seemingly as expected, with a twist.

sub count {
    state $state_var = 0;
    $state_var++;
    say $state_var;
}
say "Counting";
count();    # 1
count();    # 2
count();    # 3
say '';

### The twist is that subs get three state variables for free (no declaration 
### needed).  These free state variables are just the bare sigils '$', '@', 
### and '%'.

### Scalar state
sub count_again {
    say ++$;

    ### However, you can't just use $ all by itself.
    #say $;     # does not print the current value of the $ state variable.  Prints "(Any)".
    #.say;      # same deal
}
say 'Counting again';
count_again();
count_again();
count_again();
say '';


### Goofy and bizarre, but works.
say "Weird state iteration";
{ say ++$; say $++; say '-----' } for ^3;
''.say;


### Array state
sub collect($x) {
    say (@).push($x);
}
say 'Collect';
collect('a');   # [a]
collect('b');   # [a b]
collect('c');   # [a b c]
say '';

### Hash state
### There's one of these too, but I can't see ever using either the array 
### state or this hash state thing, at least not the defaults.


### augment
###
### First, start with this class:
class MyInt {
    has $.value is rw = 1;
}

### Great.  Now add a method to that existing class.  We have to enable 
### MONKEY-TYPING to do this.
use MONKEY-TYPING;
augment class MyInt {
    method is-answer { self.value = 42 }
}
say "Monkey type";
my $j = MyInt.new();
say $j.is-answer;
say '';

### Yay.  The tut specifically says that doing this is "strongly discouraged".  
### I have no problem with avoiding this.





### supersede
###
### "supersede" exists, but the tut lists it as a header only with no 
### information on how to use it.
###
class MySuper {
    has $.value is rw = 1;
    method sayit {
        say $!value;
    }
    method supersede_me {
        say $!value;
    }
}

### Based on the definition in the table at the top of the tut, "replace 
### definition of existing name", I assume the idea is to do something like 
### this:
    #supersede class MySuper {
    #    method supersede_me {
    #        say ($!value + 1);
    #    }
    #}
### However, that doesn't work.
###
### And it would make me feel kinda dirty if it did.




### temp
###
### This is the new name for "local".  It changes the value of an existing 
### variable, but restores its old value at the end of the block, rather than 
### creating a new lexically-scoped variable the way 'my' does.
my $foo = 'foo';
say $foo;   # foo
{
    temp $foo = 'bar';
    say $foo;   # bar
}
say $foo;   # foo
say '';


### let
###
### Similar to temp, but restores the old value if the block exits 
### unsuccessfully.
my $ans = 42;

{
    let $ans = 84;

    ### Pick one.
    die if True;
    #die if False;

    CATCH {
        default {
            say "It's been reset!"  # only hits if we died.
        }
    }
    say "--$ans--"; # does not hit if we died.
}
say $ans;   # 42 if we died in the block, 84 if we did not.



