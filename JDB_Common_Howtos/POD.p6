#!/home/jon/.rakudo/install/bin/perl6 --doc

=head1 Synopsis URL - L<https://design.perl6.org/S26.html>

=begin Displaying
    You can pass the --doc arg to perl6 to see the Pod in here on the CLI:
            $ perl6 --doc POD.p6

    But I've also dicked with the shebang line in here, so just executing this
            $ ./POD.p6
    will do the same thing.

    To produce HTML documentation:
            $ perl6 --doc=HTML > output.html
        This requires that you have Pod::To::HTML installed (use panda).

    My guess is that you can produce any type of output as long as you have 
    the correct Pod::To::<whatever> module installed.

    This section gets displayed, including the newlines, because it's a 
    begin/end section.
=end Displaying
    
=for Name
    It looks like we're now officially calling it "Pod", rather than POD.
    https://design.perl6.org/S26.html

=for Howto
    This is an example of a Paragraph block.  It ends at the first blank line, 
    with no need for an ending Pod command.

=for Indentation
    I tend to indent as you can see throughout, though it's not necessary.

=for comment
    This particular paragraph block does NOT get displayed, because we named 
    it 'comment'.  However, note that there is a big chunk of vertical blank 
    space in the output (on the CLI at least) in place of this block.




=head1 This is an 'abbreviated block'.




=begin InternalPod
=head1 Internal Header

    Our =begin and =end names must be one word.  "InternalPod" is OK, but 
    "Internal Pod" is not.  But spaces in headers is OK.

    Also, it looks like we can indent our pod now, and we don't need blank 
    vertical lines around the individual Pod specifiers.

    Look - no =over or =back needed!
    =item list item 1
    =item list item 2
    =item list item 3
=end InternalPod





=begin DeclaratorBlocks
    '#|' documents the declaration on the following line.
    
    I think that you're supposed to be able to use these declarator blocks to 
    document attributes as well as classes and methods, but for now at least, 
    the output looks bad enough that I've skipped doing it.

    The Pod::To::HTML module is (hopefully) not in its final state, because 
    the declarator blocks below look like absolute dogshit in HTML right now.
    You can supposedly
=end DeclaratorBlocks

#| Represents a person.
#| Can I do this on multiple lines?
#| Yes, I can!
class Person {
    has $.fname;
    has $.lname;

    #|{ Says hello to our Person.
        This curly brace thing is another way to do a declarator block with 
        multiple lines.  
        
        My newly-updated perl6.vim file seems like it can deal with this.
    }
    method greet() {
        say "Hello, {$.fname}!";
    }
}

### The #| declarator block gets attached to the item's WHY attribute.  So if 
### we run this script without the --doc arg, the 'say' below will print out 
### the content of the Declarator Block preceding the Person class.
my $p = Person.new;

### .WHY spits out the documentation attached by a declarator block.
say $p.WHY;             # Represents a person. Can I do this on multiple lines? Yes, I can!
say $p.WHY.contents;    # [Represents a person. Can I do this on multiple lines? Yes, I can!]
''.say;

### .WHY.WHEREFORE takes that Pod object and gives you back the thingy that 
### the Pod object is attached to.
say $p.WHY.WHEREFORE;   # (Person)



=for Nesting
    The docs say I should be able to do this to nest, but it makes no 
    difference in the output.

=begin para :nested(3)
three
=end para






=begin FormattingCodes

B<This should be bold.>

C<my $str = "This should look like code.";>

I<This should be in italics.>

B<We can now nest I<formatting codes inside> other formatting codes.>


You can use multiple angle brackets as your B<<delimiters>>.  Angle-bracket 
delimited code can contain stuff with the same number of angle brackets or 
fewer, but not more.

So if we wanted to show some hash access code, these would be legal:

C< say $foo<bar> >

Here, the separation between Pod and code is easier to see.
C<< say $foo<bar> >>

But we could not do this, because we're containing more angles than we used in 
our delimiters  - the output is all mucked up:
C< @foo >> .meth  >

=end FormattingCodes



### Tables


### Works, though the output is quite run-together.
=table
    jon         barton
    kermit      jackson


### Produces the same output as above.  The 'caption' does not display at all.
=for table :caption<CDS Employees>
    jon         barton
    kermit      jackson




say "If you just ran this without having the code open, you're going to have";
say "no idea what just happened.";

