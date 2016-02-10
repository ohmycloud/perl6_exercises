#!/home/jon/.rakudobrew/bin/perl6

use Bailador;

### http://localhost:3000/
get '/' => sub {
    "Hello, World!"
}

### http://localhost:3000/hello/jon
### http://localhost:3000/hello/steve (etc)
get '/hello/:name' => sub (Match $name) {
    "Hello, $name!"
}

### http://localhost:3000/h
### http://localhost:3000/help
### http://localhost:3000/halp
get any('/h', '/help', '/halp') => sub {
    "You may well be beyond help.";
} 

### http://localhost:3000/query?text=foo
### http://localhost:3000/query?text=bar (etc)
get '/query' => sub {
    "Value of 'text' in query string: " ~ (request.params<text> // '');
    ### params gets both GET and POST.  POST overwrites GET.
}



baile;
