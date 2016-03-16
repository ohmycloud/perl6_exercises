
### TLE datetime string format:
###     16 03 2016 17:53:27 -0400

#| Parse out a TLE datetime string
grammar Games::Lacuna::DateTime::Grammar {
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

#| Return a DateTime object from a parsed TLE datetime string
class Games::Lacuna::DateTime::Actions {
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

#| DateTime descendant that knows how to translate to and from TLE datetime strings.
class Games::Lacuna::DateTime is DateTime {

    #| Constructor.
    #| Requires a TLE datetime string.
    #|      my $tle_dt_obj = Games::Lacuna::DateTime::from_tle( $tle_datetime_string );
    method from_tle (Str $tle_stamp) {
        my $grm = Games::Lacuna::DateTime::Grammar.new;
        my $dt  = $grm.parse( $tle_stamp, :actions(Games::Lacuna::DateTime::Actions.new) ).ast;
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

    #| Returns a TLE datetime string.
    #|      say $tle_dt_obj.to_tle();
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

