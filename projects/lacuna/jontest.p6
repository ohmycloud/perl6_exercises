#!/usr/bin/env perl6


if True {# {{{

my %p;
%p<members> = [{:id("2115"), :name("Dementia")}, {:id("2403"), :name("Infinate Ones")}, {:id("15008"), :name("Space Herpes")}, {:id("19748"), :name("jof")}, {:id("22581"), :name("KC1")}, {:id("22718"), :name("Trancendance")}, {:id("23598"), :name("tmtowtdi")}, {:id("24905"), :name("Mythrandia")}, {:id("26469"), :name("Galactic Enterprise")}, {:id("26925"), :name("Chodes Empire")}, {:id("33563"), :name("carbonhalo")}, {:id("33730"), :name("Land_of_the_Free")}, {:id("33861"), :name("Silmarilos")}, {:id("36101"), :name("xLeinaDX")}, {:id("36112"), :name("ViOl3nc3")}, {:id("36277"), :name("Trade Federation")}, {:id("36408"), :name("Jarvisopolis")}, {:id("36635"), :name("Spock")}, {:id("37374"), :name("Zorn")}, {:id("37877"), :name("The Eldar")}, {:id("38165"), :name("LeatherNeck League")}, {:id("39688"), :name("Calradia")}, {:id("40124"), :name("Grimtooth")}, {:id("40285"), :name("SargePL")}, {:id("41974"), :name("Lapis Land")}, {:id("42431"), :name("Toftberg")}, {:id("42495"), :name("Izdihari Star Empire")}, {:id("42499"), :name("peppinik")}, {:id("42760"), :name("Etnmarchand")}, {:id("42794"), :name("mystery")}, {:id("42804"), :name("WatchmanCole")}, {:id("42831"), :name("Foopah")}, {:id("42862"), :name("Salidus")}, {:id("42865"), :name("Zeus43")}, {:id("42883"), :name("Calaine")}, {:id("42903"), :name("Shermatyde")}, {:id("42918"), :name("wiseupu2")}, {:id("42992"), :name("Trudevil")}, {:id("43047"), :name("Bretai")}, {:id("43268"), :name("Petronius")}, {:id("43366"), :name("Spirithawke")}, {:id("43480"), :name("Discordia")}, {:id("43489"), :name("Talborias")}, {:id("43629"), :name("Coriolis")}, {:id("43653"), :name("Nemordiabel")}, {:id("44050"), :name("The Collective")}, {:id("44816"), :name("Zephyr")}, {:id("46099"), :name("The Empire of Etlite")}, {:id("46101"), :name("Iralian Empire")}, {:id("50401"), :name("Ticcor")}, {:id("50831"), :name("Collectors")}, {:id("50918"), :name("Test.Of.Test")}];

%p<members>.WHAT.say;

for %p<members>.values -> $m {
    say $m<name>;
}


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



