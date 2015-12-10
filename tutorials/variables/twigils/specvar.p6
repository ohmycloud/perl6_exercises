#!/home/jon/.rakudobrew/bin/perl6

### 
### $? variables are compile-time.
### http://doc.perl6.org/language/variables#Compile-time_variables
### 
###
### There's a chunk of commented-out complaining below.  Keep scrolling past 
### that to see about Dynamic variables.
###




### Self-explanatory:
say "This file is $?FILE";
say "This is on line number $?LINE";

### Deals with leading tabs in a heredoc or POD block.
say "Our tabstop is set to $?TABSTOP";  # 8
say "";



foobar();
sub foobar() {
    ### &?ROUTINE gives us a sub object, not a string.

    ### If we're using it by itself, it'll stringify out OK.
    say &?ROUTINE;  # sub foobar () { #`(Sub|63672544) ... }

    ### But if we're trying to concatenate it, the fact that it's an object 
    ### being cat'd to a string will cause a splosion.
    ###
    ### The tilde, not the period, is the cat operator in perl6.
    #say "We're in the sub " ~ &?ROUTINE;    # Sub object coerced to string (please use .gist or .perl to do that)

    ### So instead, do what the error message says:
    say "We're in the sub " ~ &?ROUTINE.perl;
    say "We're in the sub " ~ &?ROUTINE.gist;   # output same as ".perl".

    say "";
}




###
### PACKAGE and CLASS
###
say $?PACKAGE;  # (GLOBAL)

### blows up, but we're not in a class right now.
#say $?CLASS;

class Jontest {
    method foo {
        ### Here $?CLASS works, since we are in a class.
        say $?CLASS;        # (Jontest)

        ### Note also that $?PACKAGE changes inside a class
        say $?PACKAGE;      # (Jontest)
    }
}
my $j = Jontest.new();  # Jontest->new() blows up.  Gonna bite me.
$j.foo();

### Now this is back to normal.
say $?PACKAGE;      # (GLOBAL)


### 
### NYI
###
### All of the following produce undeclared errors.  I'm unsure if these are 
### unimplemented or they're just being called in the wrong context.
###

### The docs at http://doc.perl6.org/language/variables#The_%3F_Twigil tell me 
### that I can redefine compile time variables like this:
#constant $?TABSTOP = 4;
### ...however, running that tells me "Constants with a '?' twigil not yet 
### implemented. Sorry."
###
### So $?TABSTOP works, but setting it does not.

#say %?LANG;
#say %?RESOURCES;
#say $?SCOPE;
#say $?MODULE;
#say $?ROLE;
#say $?GRAMMAR;
#say $?USAGE;
#say $?ENC;




### 
### $* are Dynamic variables.
###

### Magic command-line input handle
say $*ARGFILES.perl;    # IO::Handle.new(path => Any, chomp => Bool::True)

### CLI args.
###
### $ ./specvars.p6:
say @*ARGS;             # []
###
### $ ./specvars.p6 foo
say @*ARGS;             # [foo]

### STDIN, STDOUT, STDERR
say $*IN;
say $*OUT;
say $*ERR;

say "Modules installed/loaded: $*REPO";                     # inst#/home/jon/.perl6/2015.11-357-g587f700
say "Virtual machine: $*VM";                                # moar (2015.11.34.gc.3.eea.17)
say "Local time zone in seconds: $*TZ";                     # -18000
say "Current working directory: $*CWD";                     # "/home/jon/work/rakudo/tutorials/twigils".IO
say "PID: $*PID";                                           # 12345 <or whatever>
say "I am called: $*PROGRAM-NAME";                          # ./specvar.p6 <HYPHEN, not underscore!>
say "I live at: $*PROGRAM";                                 # path to location of exe.  Not sure how this differs from PROGRAM-NAME.
say "My perl is called: $*EXECUTABLE-NAME";                 # perl6
say "My perl is at: $*EXECUTABLE";                          # /home/jon/.rakudobrew/bin/../moar-nom/install/bin/perl6
say "You're logged in as: $*USER";                          # jon
say "Your primary group is: $*USER";                        # jon
say "Your home is at: $*HOME";                              # /home/jon
say "IO::Spec subclass for this platform: " ~ $*SPEC.perl;  # IO::Spec::Unix


### Some of these variables produce different output if you're concatenating 
### them with a string or not:
say "Kernel I'm compiled for: $*KERNEL";    # linux
say $*KERNEL;                               # linux (3.13.0.71.generic)

say "Perl I'm compiled for: $*PERL";    # Perl 6
say $*PERL;                             # Perl 6 (6.b)

say "Distro: $*DISTRO"; # ubuntu
say $*DISTRO;           # ubuntu (14.4.3.LTS.Trusty.Tahr)    <that's handy>




