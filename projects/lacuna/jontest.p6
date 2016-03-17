#!/usr/bin/env perl6


if True {# {{{


my %h = (jon => 'barton');
%h = ();
say %h;
say %h.WHAT;
exit;



my %resp;
%resp<result><empire><bodies> = :colonies($[{:empire_id("23598"), :empire_name("tmtowtdi"), :id("184926"), :name("bmots rof 1.1"), :orbit("1"), :star_id("65281"), :star_name("SMA bmots 001"), :x("-297"), :y("134"), :zone("-1|0")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("478857"), :name("bmots rof 1.2"), :orbit("2"), :star_id("65281"), :star_name("SMA bmots 001"), :x("-296"), :y("133"), :zone("-1|0")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("483187"), :name("bmots rof 1.3"), :orbit("5"), :star_id("2181"), :star_name("Glab"), :x("1203"), :y("-1449"), :zone("4|-5")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("473071"), :name("bmots rof 1.4"), :orbit("4"), :star_id("65281"), :star_name("SMA bmots 001"), :x("-297"), :y("130"), :zone("-1|0")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("470140"), :name("bmots rof 1.5"), :orbit("5"), :star_id("65281"), :star_name("SMA bmots 001"), :x("-299"), :y("130"), :zone("-1|0")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("470141"), :name("bmots rof 1.6"), :orbit("6"), :star_id("65281"), :star_name("SMA bmots 001"), :x("-300"), :y("131"), :zone("-1|0")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("604255"), :name("bmots rof 1.7"), :orbit("3"), :star_id("50269"), :star_name("01 Star of The Queen"), :x("-466"), :y("-241"), :zone("-1|0")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("108756"), :name("bmots rof 2.1"), :orbit("1"), :star_id("15320"), :star_name("Oot Yaeplie Oad"), :x("289"), :y("-1116"), :zone("1|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("144484"), :name("bmots rof 2.2"), :orbit("2"), :star_id("15320"), :star_name("Oot Yaeplie Oad"), :x("290"), :y("-1117"), :zone("1|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("110199"), :name("bmots rof 2.3"), :orbit("6"), :star_id("11981"), :star_name("Oasuloec"), :x("1208"), :y("-1201"), :zone("4|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("111653"), :name("bmots rof 2.4"), :orbit("4"), :star_id("15320"), :star_name("Oot Yaeplie Oad"), :x("289"), :y("-1120"), :zone("1|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("110201"), :name("bmots rof 2.5"), :orbit("3"), :star_id("20181"), :star_name("Ev Ghiehou Oah"), :x("1207"), :y("-999"), :zone("4|-3")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("217046"), :name("bmots rof 2.6"), :orbit("6"), :star_id("15320"), :star_name("Oot Yaeplie Oad"), :x("286"), :y("-1119"), :zone("1|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("110203"), :name("bmots rof 2.7"), :orbit("7"), :star_id("15320"), :star_name("Oot Yaeplie Oad"), :x("286"), :y("-1117"), :zone("1|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("82651"), :name("bmots support 01"), :orbit("1"), :star_id("11967"), :star_name("Gho Xoahlae"), :x("1001"), :y("-1198"), :zone("4|-4")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("76901"), :name("bmots support 02"), :orbit("1"), :star_id("20181"), :star_name("Ev Ghiehou Oah"), :x("1206"), :y("-996"), :zone("4|-3")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("84292"), :name("bmots support 03"), :orbit("1"), :star_id("2181"), :star_name("Glab"), :x("1205"), :y("-1445"), :zone("4|-5")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("157231"), :name("bmots01"), :orbit("7"), :star_id("2181"), :star_name("Glab"), :x("1202"), :y("-1446"), :zone("4|-5")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("360565"), :name("bmots07"), :orbit("2"), :star_id("1789"), :star_name("SMA App 39 I Blow"), :x("1326"), :y("-1456"), :zone("5|-5")}, {:empire_id("23598"), :empire_name("tmtowtdi"), :id("844994"), :name("bmots08"), :orbit("5"), :star_id("65080"), :star_name("Schu Ize"), :x("-304"), :y("125"), :zone("-1|0")}]); 

my %colonies;


%resp<result><empire><bodies><colonies>.map({ %colonies{.<id>} = 1 });
%colonies.say;





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



