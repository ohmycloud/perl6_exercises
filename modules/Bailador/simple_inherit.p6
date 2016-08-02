#!/usr/bin/env perl6

use v6;
use Bailador;
use Bailador::App;


### This sets up an app more or less identical to ./hello.p6
class MyWebApp is Bailador::App {
    submethod BUILD(|) {
        self.get: '/' => sub { "hello world (inherit)" }
    }
}

### Instantiate our class, then use Bailador's app() function to set our app 
### object to be the default.
my $myapp = MyWebApp.new;
app $myapp;

### Now baile() knows to use $myapp
baile;

