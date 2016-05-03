#!/usr/bin/env perl6

use JSON::Tiny;

my %config = (
    DEFAULT => {
        :api_key('perl6 default api key'),
        :server('us1'),
        :user('tmtowtdi'),
    },
    pt_sitter => {
        :server('pt'),
        :user('tmtowtdi'),
        :pass('hi vas'),
    },
    pt_real => {
        :server('pt'),
        :user('tmtowtdi'),
        :pass('bookshelf lamp'),
    },
    us1_sitter => {
        :server('us1'),
        :user('tmtowtdi'),
        :pass('window printer spring'),
    },
);


sub write {
    my $json = to-json(%config);
    my $io = 'lacuna.json'.IO;
    spurt $io, $json;
}

sub read {
    my $io = 'lacuna.json'.IO;
    say $io.WHAT; exit;
    my $json = slurp 'lacuna.json';
    my %config_again = from-json($json);
    say %config_again;
}

write();
#read();
