#!/home/jon/.rakudobrew/bin/perl6

=begin SYNOPSIS
Hot damn it looks like I can finally stop with all the ridiculous extra vertical whitespace!
=end SYNOPSIS


=begin table :caption<Table of Contents>
Constants           1
Variables           13
Subroutines         20
Everything Else     25
=end table


### This is actually working, it just looks like shit because the headers are 
### centered instead of left justified.
=begin table :caption<More Complicated Table>
    Name       Description of
               Duties
    =========  ===================================
    Jon        I do some stuff.  And then
               I do some other stuff.

    Kermit     He also does some stuff, and
               also some other stuff.

    John       He also does some stuff, and
               also some other stuff.
=end table

=AuthorName     Jon Barton
=AuthorEmail    jdbarton@gmail.com


=begin para1 :nested
Level 1 nest
=begin para2 :nested
Nested sections do need to use different names.
=end para2
=end para1

=begin para3 :margin<|>
    |This should work but does not.
    |This should work but does not.
    |This should work but does not.
=end para3


=Programmers

### Gets me a single-level list, but no bullets in HTML and my mname and lname 
### are not being set as a second-level list (and they should).  The # chars 
### should force numbering, but they just get printed.
=item1   # Jon
=item2      # David
=item2      # Barton
=item1   # Kermit
=item1   # John


### This doesn't work either
=for item1 :numbered
Jon
=for item2 :numbered
Barton
=for item1 :numbered
Kermit
=for item1 :numbered
John


=Subroutines

#|{ Says Hi to someone by name.
    No default name is in play and I'm only still typing to indicate that 
    this construct allows multiple lines of text.
}
sub greet (Str $name) {
    "Hi, $name!"
}


my $var = 3;
say $var;

