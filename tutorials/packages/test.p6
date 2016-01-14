#!/home/jon/.rakudobrew/bin/perl6

use lib 'lib';

my $mod = 'Linux';
#my $mod = 'Win32';

 use Win32::CurrentOS;          # works
#use Linux::CurrentOS;          # works
#use <$mod>::CurrentOS;         # ! works, doesn't matter if we use {} or () or <> or whatever.

my $os = CurrentOS.new();
say $os.report;

