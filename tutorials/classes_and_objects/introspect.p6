#!/home/jon/.rakudobrew/bin/perl6

### Same as in ./inherit.p6
class Person {#{{{
    has $.name;

    method greet() {
        "Hello, $!name.";
    }
}#}}}
class Employee is Person {#{{{
    has $.salary = 50_000;

    method weekly_pay() {
        my $wp = ($!salary / 52);
        $.name ~ " gets \$$wp per week.";   # Can't use $!name - that's private to Person.
    }
}#}}}
class Programmer is Employee {#{{{
    has @.languages;

    method new(:$name, :$salary, :@languages) {
        my $obj = self.bless(:$name, :$salary, :@languages);

        if $obj.languages.grep({$_.lc eq 'php'}) {
            die "PHP is the suxor!";
        }
        return $obj;
    }

    method php() {
        my @resp;
        for @.languages -> $l {
            @resp.push("$l is better than PHP.");
        }
        return @resp.join("\n");
    }

    ### Override the greet() method we inherited from Person
    method greet() {
        "Hello, " ~ $.name ~ ", you are a fellow geek.";
    }
}#}}}


my $name    = 'Jon';
my $salary  = 75_000;
my $j_pro   = Programmer.new(:$name, :$salary, languages => <Perl5 Perl6 Python>);


###
### Now check on what kind of thingy $j_pro really is.
###

### All of these hit.
if $j_pro ~~ Person         { say "j_pro is a Person."; }
if $j_pro ~~ Employee       { say "j_pro is a Employee."; }
if $j_pro ~~ Programmer     { say "j_pro is a Programmer."; }
''.say;

### .WHAT returns the type object, giving us the exact type of $j_pro.
say $j_pro.WHAT;    # (Programmer)

### .perl returns, essentially, Dumper output, which can be eval'd.
say $j_pro.perl;    # Programmer.new(languages => ["Perl5", "Perl6", "Python"], salary => 75000, name => "Jon")
''.say;


###
### When calling a method prefixed with a carat, we're calling a method on the 
### object's meta class, rather than on the object itself.
###
### So this shows us the methods available to $obj:
###     $obj.^methods
###



### Get all methods that can be called on $j_pro, including those inherited 
### from parents.
###
### This produces a bunch of warnings ("Method object coerced to string 
### (please use .gist or .perl to do that)"), but eventually produces output:
###     new, php, greet, languages, weekly_pay, salary, name, greet
say $j_pro.^methods.join(', ');
'--------'.say;

### This version, with the ".perl", doesn't produce any warnings, but produces 
### a string instead of an array of methods, and since it's eval-able, the 
### string is ugly.  The string below got re-formatted by vim:
###     (method new (Programmer $: :$name, :$salary, :@languages, *%_) { 
###     #`(Method|89676936) ... }, method php (Programmer $: *%_) { 
###     #`(Method|89677088) ... }, method greet (Programmer $: *%_) { 
###     #`(Method|89677240) ... }, method languages (Mu:D \fles: *%_) { 
###     #`(Method|89677392) ... }, method weekly_pay (Employee $: *%_) { 
###     #`(Method|89677544) ... }, method salary (Mu:D \fles: *%_) { 
###     #`(Method|89677696) ... }, method name (Mu:D \fles: *%_) { 
###     #`(Method|89677848) ... }, method greet (Person $: *%_) { 
###     #`(Method|89678000) ... })
say $j_pro.^methods.perl;
'--------'.say;

### Adding the (:local) argument to ^methods() displays only the methods that 
### were defined in the Programmer class.  So the output looks the same as the 
### previous call to ^methods(), but it's shorter:
say $j_pro.^methods(:local).perl;
'--------'.say;

### ^name() just gives us the name of the class, in this case, "Programmer" 
### (without the quotes.)
say $j_pro.^name;


