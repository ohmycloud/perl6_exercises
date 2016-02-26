#!/home/jon/.rakudobrew/bin/perl6


### 
### All built-in types:
###     http://doc.perl6.org/type.html
### 
### There are a lot of builtin types, so do read that URL and get familiar 
### with it.
###
### However, that URL is purely a reference, so notes are in here.
### 

{   # Bool {#{{{

### An undefined Bool does not default to either True or False:
my Bool $bool;
say $bool;          # (Bool)

### However, that undefined value still evaluates to False:
if $bool { say "We'll never get here with an undefined boolean." }

### The actual boolean values are "True" and "False", case-sensitive.
$bool = True;
say $bool;          # True
$bool = False;
say $bool;          # False

}#}}}
{   # Mu#{{{

=begin a

A variable with no type constraint on declaration is of type "Mu", which 
is a Japanese and Korean word meaning "not have, without".  Perl6 is also 
backronyming it (and I'm verbing nouns) as "Most Undefined".

When you declare a variable this way:
    my $var;

The type of the variable is "Mu".  But the value assigned to the variable is an 
object of type Any.

=end a
    
}#}}}

