#!/home/jon/.rakudobrew/bin/perl6

=begin pod

    $_      "it", as expected.
    $/      regex match
    $!      exceptions

=end pod


### 
### $_
### 

for <a b c> { say $_; }
say '';

### However, to use $_ as the default arg to a builtin, we have to let Perl 
### know that "say" is acting as a method by adding the .  on the front:

#for <d e f> { say; }   # no worky-worky
for <d e f> { .say; }   # and there was much rejoicing
say '';

### We can also use 'given':
given 'a' { say $_ };
given 'a' { .say };

### also outside of a block:
.say given 'a';
say '';

### A CATCH block sets $_ to the caught exception.
### However, I don't understand CATCH blocks yet; if we die here, the CATCH 
### block does fire, but the code goes no further.  There's gotta be a 
### continue or some such to allow us out of the CATCH block, but I haven't 
### gotten that far yet.
#die "flurble!";
#CATCH { say "--$_--"; }

### regex matches automatically work on $_:
say "Looking for strings with non-alphabetic characters...";
for <ab:c d$e fgh ij*> {
    .say if m/<!alpha>/;
}
say '';
### GONNNNG!  Docs say that the above should NOT print out the "fgh", which 
### makes sense.  However, that "fgh" IS getting printed here.
###
### But that's a problem with regex, and here we're talking about $_, which 
### seems to be working.



### 
### $/
###

'abc 12' ~~ /\w+/;      # Sets $/ to a Match object
say $/.Str;             # abc


### We can also use $/ positionally:
'foobar' ~~ /(foo)(bar)/;
say $/[0];              # ｢foo｣
say $/[1];              # ｢bar｣

### But those weird half-brackets are kinda fucked-up looking, and probably 
### not what we want, so be sure to stringify:
say $/[0].Str;          # foo
say $/[0].Str;          # bar

### We can get lazy and access those same matching groups with these digital 
### variables:
say $0.Str;             # foo
say $1.Str;             # bar

### We can also just get all members of the group.  All of these are the same:
say $/.list;            # (｢foo｣ ｢bar｣)
say @$/;                # (｢foo｣ ｢bar｣)
say @();                # (｢foo｣ ｢bar｣)

### So we could do this:
say @().join;           # foobar

### named regex matches are also available with $/, but I've never used named 
### regex matches, so won't bother with an example here.
say '';


### 
### $!
###

### If a try block catches an exception, it gets stored in $!.
try { die "foo"; }

### Keep in mind that printing a raw object can produce different output than 
### printing it stringified:
say $!;
    ### foo
    ###     in block <unit> at ./it.p6:97

say "--$!--";
    ### --foo--


### But remember that, if you include a CATCH block, the exception gets stored 
### in $_ inside that block, rather than $!.
try {
    die "dead again";
}
CATCH {
    ### dunno why, but this isn't printing.  I definitely need to read about 
    ### try/catch; I'm not getting it yet.
    say $_;
}
say "blarg";


### Also note though, that there are two CATCH blocks in this script.  The 
### first one, a page or so up, doesn't do anything, and might be commented 
### out.  If you un-comment it, the most recent CATCH block produces an error:
###     Only one CATCH block is allowed
###
### WTF?  What do you mean only one catch block?



