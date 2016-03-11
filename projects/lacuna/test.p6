#!/usr/bin/env perl6

use v6;
use lib 'lib';
use Games::Lacuna;

my $user    = 'tmtowtdi';
my $pass    = 'hi vas';     # THIS IS GETTING CHECKED IN TO GITHUB DON'T USE A REAL PASSWORD HERE
my $server  = 'pt';


### Create account object.  This does not log you in.
###
### Named args, so either version works.
#my $a = Games::Lacuna::Account.new(:$user, :$pass, :$server);
my $a = Games::Lacuna::Account.new(:$server, :$user, :$pass);

### And since the class defaults to us1, we can skip the :server arg 
### altogether if we're hitting production.  I'm not using this because I 
### don't want my us1 password checked in to github.
#my $a = Games::Lacuna::Account.new(:$user, :$pass);


### This does log you in.  I'm not saving the session ID anywhere at this 
### point, so each run of this re-logs-in.
$a.login();
say "After logging in, my session ID is: {$a.session_id}";


### Doesn't work.  Looks like an SSL issue.  I can live without captchas for 
### now.
#$a.fetch_captcha;

