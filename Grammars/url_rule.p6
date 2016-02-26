#!/home/jon/.rakudobrew/bin/perl6


###
### The goal here is to go from a URL in the form
###     http://www.google.com
### 
### And modify it to end up with this:
###     http://www.google.TLD
###
###
### This is not RL code -- the subdomain is required.  http://cdsllc.com won't 
### work, but that's OK for this example.
###


grammar SimpleURL {
    rule TOP {
        <protocol>'://'<address>
    }
    token protocol  { 'http'|'https'|'ftp'|'ftps' }
    rule address    { <subdomain>'.'<domain>'.'<tld> }
    token subdomain { <[a..z]> \w+ }
    token domain    { <[a..z]> \w+ }
    token tld       { <[a..z]> \w+ }
}

class SimpleURLActions {
    method TOP ($/)         { make "{$<protocol>}://{$<address>.made}" }
    method address ($/)     { make "{$<subdomain>}.{$<domain>}.{$<tld>.made}" }

    ### Just an example of changing a string to something else and allowing 
    ### that change to bubble up.
    method tld ($/)         { make 'TLD' }
}

my $match = SimpleURL.parse( 'http://www.google.com', actions => SimpleURLActions.new() );
say "============START";
say "orig matched string: $match";
say "modified URL: {$match.made}";
say "============END";



### In the Grammar
###     - we first match TOP
###     - TOP calls out to the protocol and address pieces
###     - address, in turn, call subdomain, domain, and tld.
###     - Since tld is the furthest down the chain, it's the first piece to 
###       actually match, and therefore, its Action is the first one to run.
### 
###
### In the Actions class
###     - tld() gets called first, and it calls make() to actually change the 
###       value of the TLD.
###         - That call to make() is the same as a call to $/.make(), but the 
###           method call would require parens, and ends up being noisier than 
###           just the function call.
###         - Calling make() in that tld() method sets the .ast attribute of 
###           the Grammar's tld object.
###             - As far as I can tell, the .made method we're using elsewhere 
###               is either an alias to .ast, or it's a method that returns 
###               the .ast attribute.  Older tutorials I'm seeing use .ast, 
###               but newer ones use .made, so I'm staying with .made.
###     
###     - address() is next.
###         - Neither the subdomain nor the domain parts of the address are 
###           being modified.  So address() can just access those using
###             $<variable_name>
###             - In fact, address() could also access the original TLD value 
###               ("com") in the same way -- $<tld>
###         - But the tld() method is modifying its value, and that modified 
###           value is what we want to use in our parsed address.  So 
###           address() is accessing the .made attribute of the tld.
###     
###     - Last, we bubble up to TOP()
###         - Just like with address(), we only want the original matched 
###           string for the protocol, so we can get at it with just 
###           $<protocol>.
###         - But we want TOP to return the address as modified by address(), 
###           so we get at it with $<address>.made.
###
###
### Note on "$/"
###     That's the default match variable.  We could change the Action class 
###     signatures to accept some other variable name (eg "$m").
###
###     However, things like $<protocol> are really a shortcut for 
###     $/<protocol>.  Referring to it as just "$<protocol>" only works 
###     because we're using the default match variable.
###
###     If we changed it to $m, we'd have to access "$m<protocol>" or 
###     something
###         I've actually not been able to figure out exactly how to access 
###         those bits if using any variable other than just $/.
###         I would like to figure it out just for argument's sake, but the RL 
###         answer is "use $/ in those signatures".
###





