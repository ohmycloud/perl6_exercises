#!/usr/bin/env perl6

use v6;
use NativeCall;

### Docs are in ./libcsv-3.0.3/csv.pdf
###
###
### With my knowledge of c (which is approaching zero), I'm starting to think 
### that this getting this CSV library working using NativeCall might be too 
### much for me to start with.
###
### HOWEVER, see these links before giving up:
###     https://perl6advent.wordpress.com/2010/12/15/day-15-calling-native-libraries-from-perl-6/
###     https://perl6advent.wordpress.com/2015/12/21/day-21-nativecall-backs-and-beyond-c/



my $csv_str = "one,two,three,four,five";
#my Pointer[Str] $csv_str;
#$csv_str = "one,two,three,four,five";


class CsvParser is repr('CStruct') {
    has int32 $.pstate;
    has int32 $.quoted;
    has size_t $.spaces;
    has uint8 $.entry_buf;
    has size_t $.entry_pos;
    has size_t $.entry_size;
    has int32 $.status;

    has uint8 $.options;
    has uint8 $.quote_char;
    has uint8 $.delim_char;

    #has int32 (*is_space)(unsigned char);
    #has int32 (*is_term)(unsigned char);
    has Pointer[uint8] $.is_space;
    has Pointer[uint8] $.is_term;

    has size_t $.blk_size;

    #has void *(*malloc_func)(size_t);
    #has void *(*realloc_func)(void *, size_t);
    #has void (*free_func)(void *);
    has Pointer[void] $.malloc_func;
    has Pointer[void] $.realloc_func;
    has Pointer[void] $.free_func;
};

class CsvData is repr('CStruct') {
    has int32 $.foo;
    has int32 $.bar;
}


### Works
sub csv_init() is native('csv', v3) returns CsvParser {};
my $init = csv_init();
say $init.WHO;
say 'here';


### This is going to take some work.
#sub csv_parse(Pointer[void], Pointer[void], int32,          cb1,     cb2,           Pointer ) is native('csv') {};
#                   |             |            |              |        |                |
#       I think this is my $init  |   num bytes to process    |  CB after end of rec    |
#                         pointer to input data      CB after parsing a field     user data passed to callbacks


sub cb1(Str $field, Int $bytes, $csv_obj) {
    say "cb1 got $bytes bytes";
} 
sub cb2(Str $eor_char, $csv_obj) {
    say "cb2 got --$eor_char--.";
} 


sub csv_parse(
    CsvParser is rw, 
    Str is rw,
    int32, 
    &cb1 (Str, Int, CsvParser --> int32), 
    &cb2 (Str, CsvParser --> int32),

   CsvData is rw
   #Pointer[void]

) is native('csv', v3) {};
say 'here again';



### As far as I can tell, my problem now is trying to get "data", the 6th arg, 
### passed in properly.  
###
### CsvData is a nonsense CStruct class, just for testing.
###
### In one of the examples, an open filehandle is passed in to that "data" 
### slot, and in another it's a struct of {0,0}.  
###
### "data" is a "pointer to user defined data that will be passed to the 
### callback functions when invoked".  That makes no sense to me, since the 
### two callback functions have different signatures and are doing different 
### things.






my Pointer[void] $data;
#my $data = 'foo';

my $rv = csv_parse(
    $init, 
    $csv_str, 
    $csv_str.chars, 
    &cb1, 
    &cb2, 

    $data 
);
#say $rv;













