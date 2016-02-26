#!/home/jon/.rakudobrew/bin/perl6


=begin a

Regular conditionals are mostly unchanged from p5, except:
    - Parens around the conditions are now optional 
    - If parens are used, a space after the conditional keyword is REQUIRED.

        if( foo ) {}            # GONNNNG no good
        if ( foo ) {}           # Fine
        if (foo) {}             # Fine
        if foo {}               # Fine

=end a


sub ret_bool {
    return True;
}
if (ret_bool())     { say "Parens works."; }
if ret_bool()       { say "No parens works."; }

### p6 introduces a new way to get a sub's retval, but the old way still works 
### too.
if ( my $a = ret_bool() )   { say "perl5-style ret_bool says '$a'." }
if ret_bool() -> $b         { say "perl6-style ret_bool says '$b'." }

### BE CAREFUL - with the old p5 style, the variable gets scoped to the outer 
### block, not the inner.
### It used to get scoped to the inner block, and the p6 version gets scoped 
### to the inner.
### But this works now, which could cause some confusion:
say "--$a--";


### Unless still exists, but no longer allows for an else or elsif clause.
unless ret_bool() {
    say "ret_bool returns false.";
}
#else {
#    say "Good - unless/else is @#$% confusing anyway."
#}


### 
### Given/when
###     It's back!
### The when clauses are still using the smartmatch operator, but that's 
### working differently (and hopefully more sanely) than it did in p5.
###     https://design.perl6.org/S03.html#Smart_matching
###
given ret_bool() {
    when "blargle" {
        say "ret_bool returned 'blargle' - should never happen!"
    }
    when False {
        say "ret_bool returned False.";
    }
    when True {
        say "ret_bool returned True.";
    }
    default {
        say "ret_bool returned something unexpected.";
    }
}

