
=begin pod

=head1 Throwing TLE Exceptions

When sending a bad request to TLE, the server I<should> respond with a chunk 
of JSON including the key 'error' (eg attempting to log in with the wrong 
password).

    my $rv = $.send( :$endpoint_name, :$method, @args );

    ### If $rv<error> exists, we got a standard server error ("Bad password" 
    ### or whatever).
    die Games::Lacuna::Exception.new($rv) if $rv<error>;

=end pod

#| The server is up, but the request sent produced an exception.
class Games::Lacuna::Exception is Exception {#{{{
    has $.code;
    has $.message;
    has $.data;
    has $.id;

    method new(%h) {#{{{
        return self.bless(
            :code(%h<error><code>),
            :message(%h<error><message>),
            :data(%h<error><data>),
            :id(%h<error><id>),
        );
    }#}}}

    method message() {
        "Error $!code: $!message";
    }
}#}}}

#|{
    Use this when the server didn't hand back the expected data, but it also 
    didn't hand back an exception (nothing in %retval<error>).
}
class Games::Lacuna::Broke is Exception {#{{{
    has $.resp;

    method message() {
        my $disp_resp = $!resp.chars > 80 ?? $!resp.substr(0, 80) ~~ '...' !! $!resp;
        "Unexpected (or no) response from server:\n$disp_resp";
    }
}#}}}

 # vim: syntax=perl6 fdm=marker

