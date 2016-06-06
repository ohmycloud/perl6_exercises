#!/usr/bin/env perl6 


# https://github.com/azawawi/perl6-gtk-scintilla

use v6;

use GTK::Simple::App;
use GTK::Simple::Raw;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

my $app = GTK::Simple::App.new(title => "Hello GTK + Scintilla!");

my $editor = GTK::Scintilla::Editor.new;
$editor.size-request(500, 300);
$app.set-content($editor);



### Set up colors, insert some perl (5) code, which will show up properly 
### colored.
$editor.style-clear-all;
$editor.set-lexer(SCLEX_PERL);
$editor.style-set-foreground(SCE_PL_COMMENTLINE, 0x008000);
$editor.style-set-foreground(SCE_PL_POD, 0x008000);
$editor.style-set-foreground(SCE_PL_NUMBER, 0x808000);
$editor.style-set-foreground(SCE_PL_WORD, 0x800000);
$editor.style-set-foreground(SCE_PL_STRING, 0x800080);
$editor.style-set-foreground(SCE_PL_OPERATOR, 1);
$editor.insert-text(0, q{
# A Perl comment
use Modern::Perl;

say "Hello world";
});


### However, only the code inserted by this script gets colored.
### 
### The editor ends up in rw mode, so the user is free to type more after the 
### editor appears.
###
### But anything the user adds will not be colored.



$editor.show;
$app.run;

