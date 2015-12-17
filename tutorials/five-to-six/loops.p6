#!/home/jon/.rakudobrew/bin/perl6


=begin a

Similar caveats as with conditionals.  Parens are optional, but if you use 
them, there must be a space between the keyword and the paren.

    while( 1 ) {}       # GONNNNG
    while (1) {}        # Fine
    while 1 {}          # Fine

=end a


sub ret_bool { return True; }


### Also like with conditionals, we have a new way of getting retvals:
while ( my $a = ret_bool )  { say "p5 style got $a."; last; }
while ret_bool() -> $b      { say "p6 style got $b."; last; }

### BE CAREFUL - with the old p5 style, the variable gets scoped to the outer 
### block, not the inner.
### It used to get scoped to the inner block, and the p6 version gets scoped 
### to the inner.
### But this works now, which could cause some confusion:
say "--$a--";

### Uncommenting this will show that the p6 version scoped to its inner block:
#say $b;        # Variable '$b' is not declared

### When using that new p6 style, the parens after the subname are required; 
### the following does not work:
#while ret_bool -> $b      { say "p6 style got $b."; last; }
#             ^^^ no parens
#               "Function 'ret_bool' needs parens to avoid gobbling block"


### 
### Read file by line
### 
### In p5 we never used for() for this, since for() slurped the entire file at 
### once - that's why we always used while(<$fh>).  
### 
### In p6, for() is lazy, and we use the lines method of the IO object to 
### read.
###
### Obviously, open() is also different now too, but I'm not really covering 
### that here.
###
my $inf = open 'input_file.txt', :r;
for $inf.lines { say $_ }
''.say;


### 
### 'for' and 'loop'
### 
### in p5, for and foreach are synonyms, and could be used for either list 
### iterators or c-style for loops.  in p6, foreach no longer exists.  for is 
### the list iterator ONLY.
###
my @arr = <a b c d e f>;

### This form of for loop no longer works; you have to use the arrow operator 
### as shown in the examples below.
#for my $d (@arr) { "\t$d".say; }   # "This appears to be Perl 5 code" -- the actual error message.

### With a single righthand arrow, the variable is read-only:
say "FOR, RO:";
for @arr -> $c {        # righthand arrow ->
    "\t$c".say;
    #$c = 'foo';        # "Cannot assign to a readonly variable or a value"
}

### But with a two-way arrow, the variable is rw:
say "FOR, RW:";
for @arr <-> $c {       # two-way arrow <->
    $c = 'foo';
    "\t$c".say;
}

### I just now invented the names "righthand" and "two-way" arrow.  The docs 
### I'm looking at don't give a name to either one, but I'm sure names will 
### surface eventually, and they probably won't be the names I just used.

### 
### The new "loop" keyword is only used for c-style loops.
### 
### Unlike with other loops, conditionals, etc, the parens ARE required for 
### c-style loops.  Again, the space after the keyword and before the left 
### paren is required.
###
say "LOOP:";
loop ( my $j = 0; $j <= 10; $j++ ) { "\t$j".say }
''.say;



### 
### Flow control
###
### next, last, redo are unchanged from p5.
###
### continue blocks no longer exist.  Instead, we use a NEXT block inside the 
### body of the loop.  I don't think I've ever used a continue block, but here 
### it is anyway.
###
my $str;
for 1..5 {
    next if $_ % 2;
    $str ~= $_;
    NEXT {
        $str ~= ':';
    }
}
$str.say;   # :2::4::

