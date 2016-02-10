#!/home/jon/.rakudobrew/bin/perl6

use Bailador;
Bailador::import;

get '/' => sub {
    return '<a href="/echo">Echo</a>';
}


get '/echo' => sub {
	template 'echo.tt';
}

post '/echo' => sub {
	template 'echo.tt', {text => request.params<text>};
}

baile;
