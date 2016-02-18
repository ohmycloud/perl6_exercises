#!/home/jon/.rakudobrew/bin/perl6

### x (repeat)
###
my $rep_str = 'x' x 10;
my @rep_arr = 'x' xx 10;
say $rep_str;
say @rep_arr;
''.say;


### Defined-or
###
my $undef;
my $defor_one = $undef // '1';
say $defor_one;
my $defor_two = $undef orelse say "undef variable is not defined.";
''.say;


### Ranges
###
my @range_one = 1..5;       # [1 2 3 4 5]
my @range_two = 1^..5;      # [2 3 4 5]
my @range_three = 1..^5;    # [1 2 3 4]
my @range_four = 1^..^5;    # [2 3 4]
my @range_five = ^5;        # [0 1 2 3 4]
''.say;


### Quotes
### 
### The Q{} works just fine, but it's messing up vim's syntax coloring so I've 
### commented it out.
#Q{This is a backslash -> \}.say;
｢This is a backslash -> \｣.say;

my $q_str = "this is a string.";
my @q_arr = <a b c>;
my %q_hash = (a => 'A', b => 'B', c => 'C');

say qq/str: $q_str/;
say qq/arr: @q_arr[]/;
say qq/hash: %q_hash/;
say qq/hash: %q_hash[]/;

my $var = "foobar";
my @q_arr2 = <<a $var c>>;
say @q_arr2;

my $rslt1 = qx/ls/;
say $rslt1;

my $cmd = "ls";
my $rslt2 = qqx/$cmd/;
say $rslt2;
''.say;


### Heredocs
###
my $name = "jon";

say Q:to/END/;
Heredoc with no backslash escapes (\\) and no interpolation ($name);
END

say q:to/END/;
Heredoc with backslash escapes (\\) but no interpolation ($name);
END

say qq:to/END/;
Heredoc with backslash escapes (\\) and interpolation ($name);
END





