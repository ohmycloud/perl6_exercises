#!/home/jon/.rakudobrew/bin/perl6


grammar SimpleURL {
    rule TOP {
        <protocol><sep><address>
    }
    rule address    { <subdomain>'.'<domain>'.'<tld> }
    token sep       { '://' }
    token protocol  { 'http'|'https'|'ftp'|'ftps' }
    token subdomain { <[a..z]> \w+ }
    token domain    { <[a..z]> \w+ }
    token tld       { <[a..z]> \w+ }
}

class SimpleURLActions {
#    method protocol ($m)    { 'protocol'.say; $m.say; '-------'.say }
#    method sep ($m)         { 'sep'.say; $m.say; '-------'.say }
#    method address ($m)     { 'address'.say; $m.say; '-------'.say }
#    method subdomain ($m)   { 'subdomain'.say; $m.say; '-------'.say }
#    method domain ($m)      { 'domain'.say; $m.say; '-------'.say }
    method tld ($m)         { $m.make('foo'); 'TLD'.say; $m.made.say; '------'.say; }
    method TOP ($m)         { 'TOP'.say; $<tld>.made.say; $m.make: $m.uc;  $m.say; '-------'.say }
}



### I feel like I'm almost there :(
###  
###
### What I'm trying to do here is send the url "http://www.google.com" in to 
### my grammar, change the tld to "foo", and then uppercase the whole thing.
###
### The uppercasing is happening, but the changing of the tld to "foo" (and 
### then to "FOO" on uc) is not happening. 
###
###
### The commented out Actions methods work, they just aren't what I'm playing 
### with so I commented them to reduce output noise.
###
###
###
### Run this and look at the output while reading the rest of the comments.
### 
### In method tld(), you can see that the tld really is getting changed to 
### 'foo' - see that section of the output.
###
### In method TOP(), I'm "make"ing the new string by calling uc on it, 
### uppercasing the whole thing.  You can see that this uc() is happening in 
### the output.
###
### But what I'm getting output is
###     HTTP://WWW.GOOGLE.COM
### 
### And what I'm expecting is
###     HTTP://WWW.GOOGLE.FOO
### 
###
### I can't figure out how to modify the TLD, and have that modification apply 
### to the final modification in TOP().  Or, alternately, how to access the 
### tld part of the match in TOP().
### 
###
###
### The example given on the grammars page appears to be doing exactly what 
### I'm trying to do, and that example works, but I can't manage to apply that 
### example to the code above.
###
### I've copied that example into ./tut_example.p6 and played with it a bit.  
### Still no worky worky.
###






my $match = SimpleURL.parse( 'http://www.google.com', actions => SimpleURLActions.new() );
say "============START";
say "modified URL: {$match.made}";
say "orig matched string: {~$match}";
say "============END";

