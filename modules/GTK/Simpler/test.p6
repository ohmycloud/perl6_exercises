#!/usr/bin/env perl6 

### https://github.com/azawawi/perl6-gtk-simpler

=begin foo

    This module provides a simpler API to GTK::Simple.

=end foo

use v6;
use GTK::Simpler;


if False {# {{{
    ### This is the example code per the readme.
    
    my $app = app( title => 'Hello' );

    $app.set-content(
        vbox(
            my $first_button  = button(label => 'Hello, World!');
            my $second_button = button(label => 'Bye bye!');
        )
    );

    $app.border-width           = 200;
    $second_button.sensitive    = False;

    $first_button.clicked.tap({
        say "Yes yes yes I already said hello.";
        .sensitive = False;
        $second_button.sensitive = True;
    });

    $second_button.clicked.tap({
        $app.exit
    });


    $app.run;

}# }}}
if False {# {{{
    ### This is my own modified layout that I think organizes things better.
    
    ### Set up the app
    my $app             = app( title => 'Hello' );
    $app.border-width   = 20;

    ### Define its widgets
    my $first_button    = button(label => 'Hello, World!');
    my $second_button   = button(label => 'Bye bye!');
    my $vbox            = vbox( $first_button, $second_button );

    ### Configure those widgets
    $first_button.sensitive = True;     # this is the default but it's nice to be explicit.
    $first_button.clicked.tap({
        say "Yes yes yes I already said hello.";
        .sensitive = False;
        $second_button.sensitive = True;
    });

    $second_button.sensitive = False;
    $second_button.clicked.tap({
        $app.exit
    });

    ### Jam the widgets into the app.
    $app.set-content( $vbox );

    ### Make it so.
    $app.run;

}# }}}
if True {# {{{

    ### Next attempt; make my own classes.
    ###
    ### More wordy than the previous block, and it doesn't really add anything 
    ### here.  But if I had a grid of 100 buttons (minesweeper, TLE planet 
    ### map, that sort of thing), subclassing the buttons would be helpful.
    ###
    ### Plus, I kind of like the fact that the init() method contains all the 
    ### widget configuration code in one spot, right inside the class, so it's 
    ### easier to see.

    use GTK::Simple::App;
    use GTK::Simple::Button;

    class MyApp is GTK::Simple::App {
        method new() {
            self.bless( :label('Hello') );
        }
        method init() {
            $.border-width = 20;
        }
    }

    role MyButt is GTK::Simple::Button {
        has $.app;
        has $.label;
        method new(MyApp :$app!, Str :$label = 'No Label') {
            self.bless( :$label, :$app );
        }
        submethod BUILD(:$label, :$app) {
            $!label = $label;
            $!app = $app;
        }

        ### This is often all the init that'll be needed.  In this example 
        ### script, both buttons actually do need to do some other stuff, so 
        ### they both override this.
        method init() {
            $.set_events;
        }

        ### Using the ellipsis like below makes set_events() a stub, so 
        ### implementing classes _must_ also implement their own set_events.
        ### For a button, that makes sense.  A button that isn't meant to do 
        ### anything when you click it probably shouldn't be a button.
        ###
        ### But if I were making something like a TextLabel role here, I'd 
        ### probably leave this as an empty sub (no ellipsis).  In that case, 
        ### I _might_ want something to happen if the user clicked on my text 
        ### label (or highlighted it etc), but many text labels simply won't 
        ### have any events associated with them.
        method set_events { ... }
    }

    class SButt does MyButt {
        method init() {
            $.sensitive = False;
            $.set_events;
        }
        method set_events {
            $.clicked.tap({ $.app.exit });
        }
    }

    class FButt does MyButt {
        has $.sbutt;
        method init( SButt :$sbutt! ) {
            $!sbutt = $sbutt;
            $.set_events();
        }
        method set_events() {
            $.clicked.tap({
                say "Yes yes yes I already said hello.";
                $.sensitive = False;
                $.sbutt.sensitive = True;
            });
        }
    }


    ### Set up the app
    my $app = MyApp.new;

    ### Define its widgets
    my $fbutt   = FButt.new( :app($app), :label('Hello, world!') );
    my $sbutt   = SButt.new( :app($app), :label('Bye-bye!') );

    ### Init all the things!
    $app.init;
    $sbutt.init;
    $fbutt.init( :$sbutt );

    ### I could make a class out of this too but there's no reason.
    my $vbox = vbox( $fbutt, $sbutt );

    ### Jam the widgets into the app.
    $app.set-content( $vbox );

    ### Make it so.
    $app.run;

}# }}}

