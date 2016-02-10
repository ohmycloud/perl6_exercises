#!/home/jon/.rakudobrew/bin/perl6

use Bailador;

get '/' => sub {
	'<form method="GET" action="/echo"><input name="text"><input type="submit"></form>';
}

get '/echo' => sub {
    my $text = request.params<text> // '';
	my $html = 'You said (in a GET request) ';
	$html ~= $text;
	return $html;
}

baile;
