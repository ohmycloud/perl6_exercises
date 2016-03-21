#!/usr/bin/env perl6


if True {# {{{

    use lib 'lib';
    use Games::Lacuna;
    use Games::Lacuna::Model::Profile;

    #my $m = Games::Lacuna::Model::Flurble.new();
    #say $m.name;

    my %stuff = (
        id => 1,
        name => 'test',
        image => 'test.jpg',
        public => True,
        times_earned => 43,
    );
    my $m = Games::Lacuna::Model::Medal.new(:json_parsed(%stuff));
    say $m.name;


}# }}}
if False {# {{{

    grammar Games::Lacuna::DateTimeG1 {
        my token ddigit     { \d\d };
        my token day        { <ddigit> };
        my token month      { <ddigit> };
        my token hour       { <ddigit> };
        my token minute     { <ddigit> };
        my token second     { <ddigit> };
        my token year       { \d\d\d\d };
        my token time       { <hour>\:<minute>\:<second> };
        my token timezone   { $<sign> = (<[+-]>) $<offset> = (<hour><minute>) };
        rule TOP            { <day> <month> <year> <time> <timezone> };
    }
    class Games::Lacuna::DateTimeG::Actions1 {
        method TOP($/) {
            make DateTime.new(
                :year( ~$<year>.Int ),
                :month( ~$<month>.Int ),
                :day( ~$<day>.Int ),
                :hour( ~$<time><hour>.Int ),
                :minute( ~$<time><minute>.Int ),
                :second( ~$<time><second>.Int ),
                :timezone( $<timezone>.made ),
            );
        }

        method timezone ($/) {
            my $secs = $<offset><hour>.Int * 60 * 60;
            $secs *= -1 if ~$<sign> eqv '-';
            make $secs;
        }
    }

    my $str = '16 03 2016 17:53:27 -0400';
    my $grm = Games::Lacuna::DateTimeG1.new;
    my $dt = $grm.parse( $str, :actions(Games::Lacuna::DateTimeG::Actions1.new) ).ast;
    say $dt.hour;


}# }}}
if False {# {{{

    class Games::Lacuna::DateTime2 is DateTime {
        method to_tle {
            my $sign = $.timezone < 0 ?? q<-> !! q<+>;
            ### I'm hardcoding "00" for the minute portion of the tz offset.
            ### I'm OK with this because I'm unaware of any tzs that have a 
            ### minute offset, and TLE only ever returns UTC anyway.
            sprintf(
                "%02d %02d %04d %02d:%02d:%02d %s%02d00",
                ($.day, $.month, $.year, $.hour, $.minute, $.second, $sign, ($.timezone.abs/60/60))
            );
        }
    }
    grammar Games::Lacuna::DateTimeG2 {
        my token ddigit     { \d\d };
        my token day        { <ddigit> };
        my token month      { <ddigit> };
        my token hour       { <ddigit> };
        my token minute     { <ddigit> };
        my token second     { <ddigit> };
        my token year       { \d\d\d\d };
        my token time       { <hour>\:<minute>\:<second> };
        my token timezone   { $<sign> = (<[+-]>) $<offset> = (<hour><minute>) };
        rule TOP            { <day> <month> <year> <time> <timezone> };
    }
    class Games::Lacuna::DateTimeG::Actions2 {
        method TOP($/) {
            make Games::Lacuna::DateTime2.new(
                :year( ~$<year>.Int ),
                :month( ~$<month>.Int ),
                :day( ~$<day>.Int ),
                :hour( ~$<time><hour>.Int ),
                :minute( ~$<time><minute>.Int ),
                :second( ~$<time><second>.Int ),
                :timezone( $<timezone>.made ),
            );
        }

        method timezone ($/) {
            my $secs = $<offset><hour>.Int * 60 * 60;
            $secs *= -1 if ~$<sign> eqv '-';
            make $secs;
        }
    }

    my $str = '16 03 2016 17:53:27 -0400';
    my $grm = Games::Lacuna::DateTimeG2.new;
    my $dt = $grm.parse( $str, :actions(Games::Lacuna::DateTimeG::Actions2.new) ).ast;
    say $dt.hour;
    say $dt.to_tle;
    say $str;


}# }}}
if False {# {{{


    grammar Games::Lacuna::DateTimeG3 {
        my token ddigit     { \d\d };
        my token day        { <ddigit> };
        my token month      { <ddigit> };
        my token hour       { <ddigit> };
        my token minute     { <ddigit> };
        my token second     { <ddigit> };
        my token year       { \d\d\d\d };
        my token time       { <hour>\:<minute>\:<second> };
        my token timezone   { $<sign> = (<[+-]>) $<offset> = (<hour><minute>) };
        rule TOP            { <day> <month> <year> <time> <timezone> };
    }
    class Games::Lacuna::DateTimeG::Actions3 {
        method TOP($/) {
            make DateTime.new(
                :year( ~$<year>.Int ),
                :month( ~$<month>.Int ),
                :day( ~$<day>.Int ),
                :hour( ~$<time><hour>.Int ),
                :minute( ~$<time><minute>.Int ),
                :second( ~$<time><second>.Int ),
                :timezone( $<timezone>.made ),
            );
        }
        method timezone ($/) {
            my $secs = $<offset><hour>.Int * 60 * 60;
            $secs *= -1 if ~$<sign> eqv '-';
            make $secs;
        }
    }
    class Games::Lacuna::DateTime3 is DateTime {
        method from_tle (Str $tle_stamp) {
            my $grm = Games::Lacuna::DateTimeG3.new;
            my $dt = $grm.parse( $tle_stamp, :actions(Games::Lacuna::DateTimeG::Actions3.new) ).ast;
            return self.new(
                :year($dt.year),
                :month($dt.month),
                :day($dt.day),
                :hour($dt.hour),
                :minute($dt.minute),
                :second($dt.second),
                :timezone($dt.timezone)
            );
        }
        method to_tle {
            my $sign = $.timezone < 0 ?? q<-> !! q<+>;
            ### I'm hardcoding "00" for the minute portion of the tz offset.
            ### I'm OK with this because I'm unaware of any tzs that have a 
            ### minute offset, and TLE only ever returns UTC anyway.
            sprintf(
                "%02d %02d %04d %02d:%02d:%02d %s%02d00",
                ($.day, $.month, $.year, $.hour, $.minute, $.second, $sign, ($.timezone.abs/60/60))
            );
        }
    }

    my $str = '16 03 2016 17:53:27 -0400';
    #my $grm = Games::Lacuna::DateTimeG3.new;
    #my $dt = $grm.parse( $str, :actions(Games::Lacuna::DateTimeG::Actions3.new) ).ast;
    #say $dt.hour;
    #say $dt.to_tle;
    #say $str;

    my $dt = Games::Lacuna::DateTime3.from_tle( $str );
    say $dt.hour;
    say $dt.to_tle;


}# }}}



