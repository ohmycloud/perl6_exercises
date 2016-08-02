
### $FindBin::Bin is the full path to the invoked program as a Str

unit module FindBin;
our $Bin is export(:ALL) = $*PROGRAM.abspath;

