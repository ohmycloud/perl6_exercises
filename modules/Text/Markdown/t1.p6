#!/usr/bin/env perl6

use v6;
use Text::Markdown;


#`{
    Meh.

    This module does a few things correctly, but it contains zero 
    documentation on what it considers "correct" markdown.  
    
    I did a google search for "markdown cheatsheet" and my markdown in my $str 
    below reflects the formatting I found on the first result of that search.

    Most of my markdown does not render correctly when output by this module.  
    A couple items do work correctly, so the module is trying, but most stuff 
    is broken.
    
    Not worth using.
}




my $str = q:to/EOF/;
# header 1

- 1.1
  - 2.1
    - 3.1
  - 2.2
- 1.2

*italics with splat*
_still italics with underbar_
**bold with two splats**
**bold here and _also italics here_**
~~Strikethrough~~

[this goes to google](https://www.google.com)

`inline code here`

```perl
for my $i(1..10) {
    say "This should be a perl code block.";
}
```

EOF


my $t1 = Text::Markdown.new($str);
say $t1.render;
#say $t1.to_html;



























