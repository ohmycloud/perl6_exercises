#!/home/jon/.rakudobrew/bin/perl6



### Grammar and individual classes as in two.p6
grammar Question::Grammar {
    token TOP       { \n* <question>+ }
    token question  { <header> <answer>+ }
    token header    { ^^ $<type>=['pickone'|'pickmany'] ':' \s+ $<text>=[\N*] \n }
    token answer    { ^^ \s+ $<correct>=['ac'|'ai'] ':' \s+ $<text>=[\N*] \n }
}
class Question::Answer {
    has $.text is rw;
    has Bool $.correct is rw;
}
class Question {
    has $.text is rw;
    has $.type is rw;
    has Question::Answer @.answers is rw;

    ### This method is new, but there's nothing mysterious about it.
    method ask {
        my %hints = (
            pickmany    => 'Choose all that are true',
            pickone     => 'Choose the one item that is correct'
        );
        say %hints{$.type};
        say '';
        say $.text;

        for @.answers.kv -> $i, $a {
            say "{$i+1}) {$a.text}";
        }
        print '> ';

        ### Read the user's response(s)
        my $line = $*IN.get();
        my @responses = $line.comb( /<digit>+/)».Int.sort;
    }
}


### But now we're instantiating the objects using a new Actions class
class Question::Actions {
    method TOP ($/) {
        make $<question>».ast;
    }

    ### $/ is special like $_ is.  In the case of $/, we can access its keys 
    ### by doing just "$<header>", which gets translated to "$/<header>".
    ###
    ### Saving one keystroke isn't worth the cognitive load of this 
    ### "shortcut", but there ya go.  I'm doing it below because that's the 
    ### way the tut does it.
    method question ($/) {
        make Question.new(
            text    => ~$<header><text>,
            type    => ~$<header><type>,
            answers => $<answer>».ast,
        );
    }

    method answer ($/) {
        make Question::Answer.new(
            correct => ~$<correct> eq 'ac',
            text    => ~$<text>,
        );
    }
}


### Using the same string as before
my $str = q:to/EOT/;
    pickmany: Which items are food?
        ac: Rice
        ac: Orange
        ac: Mushroom
        ai: Shoes
    pickone: Which item is a color?
        ac: Orange
        ai: Shoes
        ai: Mushroom
        ai: Rice
    EOT


### Instead of creating a match object $m, we're passing in our Actions class, 
### and calling the .ast method, which returns our array of questions.
my @questions = Question::Grammar.parse( $str, actions => Question::Actions.new() ).ast;


### works.
for @questions -> $q {
    say $q.text;

    for $q.answers.kv -> $i, $a {
        say "   {$i+1}) {$a.text}";
    }
}


