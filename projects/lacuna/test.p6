#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Games::Lacuna;

my $user    = 'tmtowtdi';
my $pass    = 'hi vas';
my $server  = 'pt';


### Create account object.  This does not log you in.
###
### Named args, so either version works.
#my $a = Games::Lacuna::Account.new(:$user, :$pass, :$server);
my $a = Games::Lacuna::Account.new(:$server, :$user, :$pass);


### This does log you in.  I'm not saving the session ID anywhere at this 
### point, so each run of this re-logs-in.
$a.login();
say "After logging in, my session ID is: {$a.session_id}";


### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

