#!/usr/bin/env perl6

### Taken from
###     https://github.com/ufobat/Bailador#example
### scroll down to "Web Applications via Inheriting..."



use v6;
use Bailador;
use Bailador::App;

use lib 'lib';
use MyWebApp;

### Instantiate our class, then use Bailador's app() function to set our app 
### object to be the default.
my $myapp = MyWebApp.new;
app $myapp;

### Now baile() knows to use $myapp
baile;

