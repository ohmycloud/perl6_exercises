#!/home/jon/.rakudobrew/bin/perl6

### 
### map, grep
###
### Builtins that accepted code followed by a list (map, grep, etc) now 
### require a comma after the code block.
my @foo = <foo bar baz bar>;
my @rslt = grep { $_ eq 'bar' }, @foo;
#                              ^ this comma is new.
say @rslt.list;
''.say;


### 
### delete, exists
### 
### These are now 'adverbs' of the subscript operators.
###
my @arr = <one TWO three>;
@arr[1]:delete;
@arr.say;  # [one (Any) three]

my %hash = (jon => 'barton', kermit => 'jackson', john => 'koch');
%hash{'kermit'}:delete;
%hash.say;  # john => koch, jon => barton

if @arr[1]:exists {
    ### NO, does not print, even though ss [1] is listed as (Any) when we dump 
    ### out @arr.  This is counter-intuitive to me; exists seems to be 
    ### behaving like defined is supposed to.
    ###
    ### As it turns out, p5 behaved the same way too.  I guess I never used 
    ### delete and exists on an array before.
    say "subscript 1 exists.";
}

if %hash{'john'}:exists {
    say "John exists.";       # hits 
}


### 
### defined
### The tut does not mention defined at all, so I tried playing with it a bit.
###

### Trying to use defined exactly as I'd use exists produces an error:
#if %hash{'john'}:defined { say "John is there."; }

### This works.  I don't know why the old style is needed for this.
if defined %hash{'john'}    { say "John is defined."; }

''.say;




