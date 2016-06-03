#!/usr/bin/env perl6


=begin example_path_structure

    ROOT
        bin/
            findbin.p6
        lib/
            FindBinLib.pm6

=end example_path_structure

### Step one - get path to the ROOT directory into a variable
### PATH RONG {# {{{
{
    say "RONG";

    my $script_dir = $?FILE.IO.parent;
    say "The script is in $script_dir.";

    my $root_dir = $script_dir.parent;
    say "The root is $root_dir.";
}
''.say;
=begin explanation

That looks like it makes perfect sense.  BUT DO NOT DO THAT.  You'll get 
different results depending on how you run the script.

        $ perl6 findbin.p6
        The script is in /home/jon/work/rakudo/JDB_Common_Howtos.
        The root is /home/jon/work/rakudo.
    
    Fine, right?  But see here:

        $ ./findbin.p6
        The script is in /home/jon/work/rakudo/JDB_Common_Howtos/..
        The root is /home/jon/work/rakudo/JDB_Common_Howtos.

    What?  WHAT?  No, no no no.

=end explanation

### }# }}}
### PATH RITE {# {{{
{
    say "RITE";

    my $script_dir = $?FILE.IO.absolute.IO.parent;
    say "The script is in $script_dir.";

    my $root_dir = $script_dir.parent;
    say "The root is $root_dir.";

    ### And now that we have the $root_dir, we can get the path to the lib 
    ### dir:
    my $lib_dir = $root_dir.child('lib');
    say "The lib dir is $lib_dir.";

    ### To boil all that down into a single line:
    my $single_lib_dir = $?FILE.IO.absolute.IO.parent.parent.child('lib');
    say "The lib dir in one expression is $single_lib_dir.";


    ### Last note.
    ### child() returns an IO::Path object.  In the assignment above, that 
    ### IO::Path is being cast to a Str.  I don't know why, but it is.
    ###
    ### But the fact that child() does return an IO::Path rather than a Str 
    ### becomes important in the next section.


    ''.say;
}
=begin explanation

Here we're not using relative paths like we did in the RONG section.  We're 
getting the absolute path instead.

FWIW, absolute() returns a string, so we have to cast it to an IO object.  But 
parent() does not return a string, but an IO object, so we don't have to cast 
that.

That behavior is fucked up and inconsistent, but it's what's happening 
06/2016.

=end explanation

### }# }}}

### Step two - use that variable in a "use lib" statement
### This is your TL;DR
### use lib $var {# {{{

    ### The whole point of the PATH RITE section above was to get our 'lib' 
    ### directory into a variable and use that like so:
    ###
    # my $inc = 'lib';              # or whatever
    # use lib $inc;
    # use FindBinLib;
    # my $j = Jontest.new;
    # say $j.name;
    ###
    ### BUT that does not work.  It produces a compile error:
    ###     Type check failed in binding $spec; expected Str but got Any (Any)
    ###
    ### The "use" statement appears to be getting compiled and run before the 
    ### assignment to $inc (which makes sense).

    ### So, we have to play with perl6's phasers.  The following works.
    ###
    my $inc;
    BEGIN { $inc = $?FILE.IO.absolute.IO.parent.parent.child('lib').Str; }  # Compile time, ASAP
    CHECK { use lib $inc; }                                                 # Compile time, ALAP
    use FindBinLib;
    my $j = Jontest.new;
    say $j.name;                # 'jon'


    ### Note how we had to cast the RHS of the assignment in BEGIN to Str.


### }# }}}

