#!/home/jon/.rakudobrew/bin/perl6


### http://doc.perl6.org/language/5to6-nutshell#Regular_Expressions_%28_Regex_%2F_Regexp_%29


my $str = "Now is the time for all good men";

### Regexen now use the smartmatch operator.
### 
### =~ becomes ~~
### !~ becomes !~~
say "match" if $str ~~ /time/;
say "correct nomatch" if $str !~~ /blargle/;


### Along with the format above, which is familiar, p6 also includes method 
### forms of m// and s///.
###
### The tut doesn't cover this stuff, I just stumbled upon it, so I'm not 
### going into depth here.  But, if you need it:
###     https://design.perl6.org/S05.html#Substitution
###
# $str.match( /pat/ );
# $str.subst( /pat/, "replacement" );





### Modifiers get moved to the front of the pattern.
###
say "CI match" if $str ~~ m:i/TIME/;


### If you've got a complex regex and want to just use p5 syntax, you can do 
### that by adding the P5 modifier:
###
say "P5 class match" if $str ~~ m:P5/[N12345]/;

### FWIW, matching a class works with angle brackets in p6:
###
### The space are not necessary, but are allowed.  I don't know the rules for 
### that yet.
###
say "P6 class match" if $str ~~ /   <[N12345]>  /;


### Other class changes
### 
###     p5                  new in p6
###     --                  ---------
###     [abc]               <[abc]>
###     [^abc]              <-[abc]>
###     [a-zA-Z]            <[a-zA-Z]>
###     [[:upper:]]         <:Upper>
###     [abc[:upper:]]      <[abc]+:Upper>
###


### look-around assertions
###
### These have changed too, but I use those rarely and always have to look 
### them up anyway.  So continue looking them up if you need them.  Explained 
### on the URL top of this file.


### Alternations
### 
### my $str = 'foobar';
###
### In p5, (foo|bar) would match the first alternative that appeared in the 
### string:
###     if( $str =~ /(bar|foo)/ ) {
###         say $1;                     # 'foo'
###     }
###
### In p6, (foo|bar) uses "Longest Token Matching" (LTM) to decide which 
### alternative to match based of "a set of rules".  That phrase, 'a set of 
### rules', is as far as the tut goes in explaining how LTM works.
###
### The simplest way to deal with this in p6 is to use || instead of the 
### single |.  Doubling the pipes (giggity!) presumably behaves the same as 
### the single pipe in p5.
###

