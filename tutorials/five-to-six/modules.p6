#!/home/jon/.rakudobrew/bin/perl6

###
### http://doc.perl6.org/language/5to6-nutshell#Importing_specific_functions_from_a_module
### 
###
### This file _does_ include a section on Core Modules.  Scroll down.
###


=begin a

In p5, we can selectively import functions:
    use Module qw(foo bar baz);

That changes in p6.  The module decides what to export.  When your code uses 
that module, you get the exported functions.




NYI

This could cause unwanted namespace pollution.  

The docs at the link talk about how to get around this, but those docs have 
lots of caveats ("right now, the current version of rakudo works like This, 
which is counter to the Synopsis but it works anyway ..."). 

It sounds to me like what's in the tut right now is not what we're going to 
end up with, so I'm not even going to bother including examples of it here.

The upshot is that p6 _is_ going to allow you to control what gets imported, 
in some fashion.  I'll want to come back to that when it gets ironed out.


...Actually, it looks like what might change is how exporting will be handled 
from the module's point of view.  But from the userland code, we'll control 
what gets imported like this:
    use Module <foo bar>;

I'm still not including examples of this since I'd have to code the module and 
don't want to bother writing down code (and getting it embedded in my skull) 
when how it works might change.


See ./TestModule.pm while looking at the rest of this.

=end a

use lib '.';
use TestModule;

### These work as expected.
foo(1);
bar(2);

### This would blow up as expected, since TestModule is not exporting it.
#baz(3);



### 
### Core Modules
###

my %my_people_hash = ( jon => 'barton', kermit => 'jackson' );

### Data::Dumper
###     No longer relevant.  Use the .perl method to dump out a structure.
###
say %my_people_hash.perl;       # {:jon("barton"), :kermit("jackson")}

### If you add a colon in front of the sigil, the dump will include the 
### variable name:
say :%my_people_hash.perl;      # :my_people_hash({:jon("barton"), :kermit("jackson")})


### Getopt
###     Options are now passed by a parameter list to sub MAIN.
###
###     Run this program as both:
###         $ ./modules.p6
###         $ ./modules.p6 --length=5 --name=foo
### 
### The code in this file outside of our declared MAIN sub does still run, but 
### now this MAIN sub runs as well, using our switch variables.
###
### You CANNOT omit the = sign on the command line as you could do with some 
### of the p5 options modules I've used in the past.
###
sub MAIN (Int :$length = 24, Str :$name = 'jon') {
    say "length is $length, name is $name.";
}

    ### I did try the above using ^, which is the twigil for positional 
    ### parameters, but that didn't work.  Note that the colon is listed as 
    ### the twigil for named parameters, but also note that in our MAIN 
    ### declaration, the colon appears before, not after, the $.
    ###
    ### So I'm unclear if that colon counts as a "twigil" above.
    ###
    ### I assume there's some way to have your program respond to positional 
    ### parameters, but the tut isn't covering that.



