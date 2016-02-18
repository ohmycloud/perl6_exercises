#!/home/jon/.rakudobrew/bin/perl6

class Person {
    has $.name;

    method greet() {
        "Hello, $!name.";
    }
}


### This time, Employee does _not_ inherit from Person.
class Employee {
    has $.salary = 50_000;

    method weekly_pay() {
        my $wp = ($!salary / 52);
        $.name ~ " gets \$$wp per week.";   # Can't use $!name - that's private to Person.
    }
}


### So now, Programmer inherits from both Person and Employee.
class Programmer is Person is Employee {
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
}



### 
### The code from here down is the same as the code in ./inherit.p6 -- 
### Programmer class works the same way.
###
my $name = 'Jon';
my $j_per = Person.new(:$name);
say $j_per.greet;
''.say;


my $salary = 75_000;
my $j_pro = Programmer.new(:$name, :$salary, languages => <Perl5 Perl6 Python>);
say $j_pro.greet;
say $j_pro.weekly_pay;
say $j_pro.php;
''.say;


