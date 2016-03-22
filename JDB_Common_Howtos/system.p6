#!/usr/bin/env perl6

### There's no "system" command anymore.  Now it's either run() or shell().



### run() runs a system command without involving the shell.
###     http://doc.perl6.org/routine/run
###
### Starting a program like gvim does not require the shell.
#run('/usr/bin/gvim');




###
### shell() runs a system command within the system shell.
###     http://doc.perl6.org/routine/shell
### 
### Opening an image using xdg-open, or running 'ls', does require the shell.  
### All of these work; uncomment what you want to see.
#shell('xdg-open test.png');
shell('ls');                    # file listing
shell('sl');                    # train

