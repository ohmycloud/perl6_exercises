#!/home/jon/.rakudobrew/bin/perl6


say "If anything below comes up 'False', a Grammar broke.";
''.say;


### A simplistic but wordy URL-matching grammar.
grammar SimpleURL {
    rule TOP {
        <protocol>'://'<address>
    }
    rule address {
        <subdomain>'.'<domain>'.'<tld>
    }
    token protocol  { 'http'|'https'|'ftp'|'ftps' }
    token subdomain { <[a..z]> \w+ }
    token domain    { <[a..z]> \w+ }
    token tld       { <[a..z]> \w+ }
}
say so SimpleURL.parse('http://www.google.com');
say so SimpleURL.parse('https://www.google.com');
''.say;


### OK, but subdomain, domain, and tld have a worrying repetition.  We could 
### shave those down a bit without losing our modularity:
grammar TokenizedStringURL {
    rule TOP {
        <protocol>'://'<address>
    }
    rule address {
        <subdomain>'.'<domain>'.'<tld>
    }
    token protocol {
        'http'|'https'|'ftp'|'ftps'
    }
    token subdomain     { <addresspiece> }
    token domain        { <addresspiece> }
    token tld           { <addresspiece> }
    token addresspiece  { <[a..z]> \w+ }
}
say so TokenizedStringURL.parse('http://www.google.com');
say so TokenizedStringURL.parse('https://www.google.com');
''.say;



### Instead of using a junction for the different protocols, we can create a 
### "proto token" that makes it easier to add new protocols later.
grammar ProtoURL {
    rule TOP {
        <protocol>'://'<address>
    }
    rule address {
        <subdomain>'.'<domain>'.'<tld>
    }

    token subdomain     { <addresspiece> }
    token domain        { <addresspiece> }
    token tld           { <addresspiece> }
    token addresspiece  { <[a..z]> \w+ }

    proto token protocol { * }
    token protocol:sym<http>    { <sym> }
    token protocol:sym<https>   { <sym> }
    token protocol:sym<ftp>     { <sym> }
    token protocol:sym<ftps>    { <sym> }
}
say so ProtoURL.parse('http://www.google.com');
say so ProtoURL.parse('https://www.google.com');
''.say;



### So far, all of our grammars have required the subdomain, but 
### "http://cdsllc.com" is a perfectly valid URL, but has no subdomain.
### 
###
### This time, we have to re-designate 'address' from a rule to a regex.
###
### This is because rules do not backtrack.  But without backtracking, our 
### subdomain-less URL will not match (follow it through carefully).  
grammar OptionalSubdomainURL {
    rule TOP {
        <protocol>'://'<address>
    }
    regex address {
        <subdomain>?<domain>'.'<tld>
    }

    token subdomain     { <addresspiece> '.' }
    token domain        { <addresspiece> }
    token tld           { <addresspiece> }
    token addresspiece  { <[a..z]> \w+ }

    proto token protocol { * }
    token protocol:sym<http>    { <sym> }
    token protocol:sym<https>   { <sym> }
    token protocol:sym<ftp>     { <sym> }
    token protocol:sym<ftps>    { <sym> }
}
say so OptionalSubdomainURL.parse('http://www.google.com');
say so OptionalSubdomainURL.parse('https://www.google.com');
say so OptionalSubdomainURL.parse('http://google.com');             # False
''.say;



my $cand = 'http://cdsllc.com';
if OptionalSubdomainURL.parse($cand) {
    say "Your candidate string looks like a URL."
}





