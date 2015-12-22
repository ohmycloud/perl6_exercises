#!/home/jon/.rakudobrew/bin/perl6

class Person {
    has $.name;

    method greet() {
        "Hello, $!name.";
    }
}

class Employee is Person {
    has $.salary = 50_000;

    method weekly_pay() {
        my $wp = ($!salary / 52);
        $.name ~ " gets \$$wp per week.";   # Can't use $!name - that's private to Person.
    }
}

class Programmer is Employee {
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


### For now, don't try to change 'languages' to just <Java>.  See ./funk.p6 
### for explanation.
my $s_pro = Programmer.new(name => 'Sil', salary => 100_000, languages => <Java Android>);
say $s_pro.greet;
say $s_pro.weekly_pay;
say $s_pro.php;

