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

{   # List funk#{{{
    
### When using the built-in constructor, this DTRT; the string 'Java' gets 
### coerced into a single-element array.
#       my $s_pro = Programmer.new(name => 'Sil', salary => 100_000, languages => 'Java');


### 
### But when using my own constructor, the above produces
###     expected Positional but got Str


### I get that same error even when I use array notation with only a single 
### element instead of a string as above:
#       my $s_pro = Programmer.new(name => 'Sil', salary => 100_000, languages => <Java>);
###  
### It looks like that single-element array is being flattened into a string.
###
### This bug report exists:
###     https://rt.perl.org/Public/Bug/Display.html?id=126792
###
### And I think that report is complaining about this same thing.



### 
### NYI
###
### So there could well be two problems here:
###     - I don't understand how to coerce a named string into an array the 
###       way the default constructor does.
###         - This might be my error, and it might have to do with the second 
###           problem; I can't tell.
###
###     - The flattening of a single-element array into a string
###         - Seems to me that
###                     languages => <java>
###           and
###                     languages => <java android>
###           should both behave the same way, and they're not.
### 
### Problem 2 is almost certainly SEP, and problem 1 may or may not be caused 
### on problem 2 (which would also make problem 2 SEP).
###
### I'm too new to this to tell.
###



### So what I'm needing to do is force 2 or more elements in there:
my $s_pro = Programmer.new(name => 'Sil', salary => 100_000, languages => <Java Android>);
say $s_pro.greet;
say $s_pro.weekly_pay;
say $s_pro.php;

}#}}}

