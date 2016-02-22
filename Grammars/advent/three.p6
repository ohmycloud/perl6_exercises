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


    ### This method is new from two.p6
    method ask {
        my %hints = (
            pickmany    => 'Choose all that are true',
            pickone     => 'Choose the one item that is correct'
        );
        say %hints{$.type};
        say $.text;

        ### 
        ### There are a lot of comments in this method.  Skip them on your 
        ### first re-read-through.  It's mostly bitching.
        ###

        for @.answers.kv -> $i, $a {
            ### Yes, this is going to number the responses starting at 0) on 
            ### output, which is not very user-friendly.  Leave it alone for 
            ### now.
            ###
            ### IRL I would add 1 to $i here, so the answers as displayed to 
            ### the user start at 1) instead of 0).  But then I'd have to 
            ### re-modify the user's answers after reading them, and we'd be 
            ### drifting further from the point of this example.
            say "{$i}) {$a.text}";
        }
        print '> ';

        ### Read the user's response(s)
        my $line = $*IN.get();
        my @responses = $line.comb( /<digit>+/)».Int.sort;

        ### Create an array of the subscripts of all of the correct answers to 
        ### this question.
        my @correct = @.answers.kv.map({ $^v.correct ?? $^k !! Empty });


        ### Now just compare the array of user responses to the array of 
        ### correct answers.  This is why we had to leave the answers numbered 
        ### starting with "0".
        ###
        ### Also, the tuto has these blocks returning either 0 or 1, which I 
        ### hate.  I changed it to return True or False, which makes more 
        ### sense.  I also changed the method of asking the questions at the 
        ### bottom of this script.
        if @responses ~~ @correct {
            say "You got it right!";
            ''.say;
            #return 1;
            return True;
        }
        else {
            say "Whoopsie, you got it wrong.";
            ''.say;
            #return 0;
            return False;
        }
    }
}


### Now we're instantiating the objects using a new Actions class
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




### Ask each question, and collect the number of correct results.

### This is the code from the tut.  It's trying too hard for brevity and 
### cleverness.  It requires that our ask() method return either 0 or 1, which 
### I don't like, and it doesn't display the total number of questions asked, 
### which I don't like.
#my @results = @questions.map(*.ask);
#say "Your final score: " ~ [+] @results;


### This looks less brief and clever, but it works whether ask() is returning 
### a 1 and 0 or True and False, it's easier to read, and it displays the 
### total number of questions asked.
my Int $total = 0;
my Int $correct = 0;
@questions.values.map({ $total++; $^v.ask ?? $correct++ !! Empty });
say "Your final score:  $correct out of $total";

