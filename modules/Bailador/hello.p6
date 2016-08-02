#!/usr/bin/env perl6

use v6;
use Bailador;

### Run at the terminal, then hit localhost:3000

### simple cases
get '/' => sub {
    "hello world"
}

baile;
