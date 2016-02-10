#!/home/jon/.rakudobrew/bin/perl6

use Bailador;
Bailador::import();

use lib callframe(0).file.IO.dirname ~ '/lib';
use Demo;

baile;

