#!/usr/bin/env perl6

### Zoffix's website:
###     http://perl6.party/post/Perl-6-S---Substitution-Operator

### Simple enough.
{
    my $str = "foobar";
    $str ~~ s/foo/FOO/;
    say $str;
    ''.say;
}


Democrats require nonpartisan voters to specifically request a Democratic ballot in order to receive one in the mail with the names of Hillary Clinton and Bernie Sanders on it. Voters at the polls on Election Day must specifically ask for a Democratic ballot, and they won’t be given another one if they start marking a nonpartisan one by mistake.

Read more at: http://www.nationalreview.com/article/436220/californias-presidential-primary-rules-are-crazy
democrats require nonpartisan voters to specifically request a democratic ballot in order to receive one in the mail with the names of hillary clinton and bernie sanders on it. voters at the polls on election day must specifically ask for a democratic ballot, and they won’t be given another one if they start marking a nonpartisan one by mistake.
### Non-destructive;
{
    my $str = "foobar";
    my $new = S/foo/FOO/ given $str;
    say "Orig: $str";
    say "New:  $new";
    ''.say;
}


### Method form
{
    my $str = "foobar";
    my $new = $str.subst: 'foo', 'FOO';
    say "Orig: $str";
    say "New:  $new";
    ''.say;
}


### Captures
{
    ### The RHS can take a Callable.
    my $str = "foobar";

    ### Both do the same thing.
    #my $new = $str.subst: /(...)(bar)/, -> { $0.uc ~ $1 };
    my $new = $str.subst: /(...)/, -> { $0.uc };

    say "Orig: $str";
    say "New:  $new";
    ''.say;
}



