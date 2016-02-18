#!/home/jon/.rakudobrew/bin/perl6

=begin Foobar

http://doc.perl6.org/language/variables#The_^_Twigil
http://doc.perl6.org/language/variables#The_%3A_Twigil

^   formal positional parameter
:   formal named parameter

=end Foobar


say $=Foobar;
exit;








### 
### ^   (Positional)
###

### ^ applies to both blocks and subroutines.  Here it is on a block.
for ^4 {
    say "$^b follows $^a."
}
### 1 follows 0.
### 3 follows 2.


### Once you've used $^b and $^a once, you've also created $a and $b.  
### However, you can continue to use the variables with the ^ twigil if that 
### blows your skirts up.  This block works:
for ^4 {
    say "$^b follows $^a.";
    say "$b follows $a.";       # No ^ twigils
    say "$^b follows $^a.";
}

### However, this does not work:
for ^4 {
    ### No ^ twigils, and $^a and $^b have not been used yet, so $a and $b are 
    ### not yet defined.
#   say "$b follows $a.";

    ### This is too late.
    say "$^b follows $^a.";
}





=begin explanation

for $^4 {
    That does NOT mean the same thing as "for 1..4 {".  The block is not going 
    to be executed four times.  It's going to be executed until all of the 
    parameters are exhausted.

    We're specifying four parameters with the $^4, and then our block is 
    consuming two parameters each each time, so the block gets executed twice.

    If we'd specified four parameters (as we're doing), and then had used up 
    three parameters in the block (eg by including $^c as well), the second 
    loop through the block would blow up, because there'd only be one 
    parameter left from our original four, but the block wants to use three:
        Too few positionals passed; expected 3 arguments but got 1
            in block <unit> at params.p6:22


    On the webpage, they use the variable names $^second and $^first in place 
    of my $^b and $^a. "second" and "first" happen to work here, but those are 
    not keywords.  variable names are sorted alphabetically (Unicode sort 
    order); "first" just happens to come before "second" in alpha order.  That 
    is not explained, and is confusing.

    I could have used eg $^c and $^q in place of my "a" and "b".  The 
    identifiers don't have to be consecutive, they're just used in alpha 
    order.
    
=end explanation


### Subs can also use these positional parameters, but only if the sub is not 
### defined using an explicit parameter list.

### So this is OK:
sub say_hello_legal {
    say "Hello, $^name.";
    say "Hi again, $^name.";    # using it again is fine

    ### But overwriting it is not fine -- $^name is read-only.
    #$^name = "Fred";
}
say_hello_legal('Jon');


### The following is not legal - the prototype specifies no args, so we can't 
### then use the first arg.
###
#sub say_hello_not_legal() {
#    say "Hello, $^name.";
#}
    ### Uncommenting this produces:
    ###     ===SORRY!=== Error while compiling 
    ###     /home/jon/work/rakudo/tutorials/twigils/params.p6
    ###     Placeholder variable '$^name' cannot override existing signature




### 
### :
###

###
### There's only one example given for this.  I get what's supposed to be 
### happening, but it looks stupid and IT DOES NOT WORK.
###
### Produces a compile error.  Copy/paste from the tutorial.
###
# say { $:add ?? $^a + $^b !! $^a - $^b }( 4, 5 ) :!add





say { $:add ?? $^a + $^b !! $^a - $^b }( 4, 5 ) :add

