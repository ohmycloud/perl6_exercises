#!/home/jon/.rakudobrew/bin/perl6



grammar Question::Grammar {
    token TOP { \n* <question>+ }
    token question { <header> <answer>+ }
    token header { ^^ $<type>=['pickone'|'pickmany'] ':' \s+ $<text>=[\N*] \n }
    token answer { ^^ \s+ $<correct>=['ac'|'ai'] ':' \s+ $<text>=[\N*] \n }
}


### These classes are new.
class Question::Answer {
    has $.text is rw;
    has Bool $.correct is rw;
}
class Question {
    has $.text is rw;
    has $.type is rw;
    has Question::Answer @.answers is rw;
}




### As before, parse out our string using our Grammar
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
my $m = Question::Grammar.parse($str);


### Create an array @questions.  Create a Question object for each question in 
### our parsed string.
my Question @questions;
for $m<question> -> $q {
    @questions.push(
        Question.new(
            text    => ~$q<header><text>,
            type    => ~$q<header><type>,

            answers => $q<answer>.map: {
                Question::Answer.new(
                    text    => ~$_<text>,
                    correct => ~$_<correct> eq 'ac'
                )
            }
        )
    )
}




### works.
say @questions;



