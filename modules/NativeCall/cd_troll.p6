#!/usr/bin/env perl6

use v6;
use NativeCall;

### pops open the CD tray, issues a bunch of warnings, then re-closes the CD 
### tray again.





###
### The functions below both come from libcdio13.
###
### Libraries always start with "lib", so we can omit that entirely, and the 
### number 13 is the library version number, so the name of the library is 
### just "cdio".  And we specifically want version 13.
###
### If we omit the "v13" arg, we'll get this error:
###     Cannot locate native library 'libcdio.so'...
### So we do need that "v13".
###
sub cdio_eject_media_drive(Str) is native('cdio', v13) {};
sub cdio_close_tray(Str, int32) is native('cdio', v13) {};

### We'd call those like this:
    # cdio_eject_media_drive Str;
    # cdio_close_tray Str, 0;
### However, those functions are pretty wordy.


### Since "cdio_eject_media_drive" and "cdio_close_tray" are too wordy, I'd 
### rather call them "open-tray" and "close-tray". 
sub open-tray(Str) is native('cdio', v13) is symbol('cdio_eject_media_drive') {};
sub close-tray(Str, int32) is native('cdio', v13) is symbol('cdio_close_tray') {};



say "Gimme a CD!";
open-tray Str;

### To prettify this, I should redirect STDERR to /dev/null or something so 
### the warnings don't get printed, but that's not really needed for an 
### example script.

sleep .5;
say "Ha! Too slow!";
close-tray Str, 0;



