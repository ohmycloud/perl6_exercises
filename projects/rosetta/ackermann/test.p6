#!/usr/bin/env perl6

subset Pos of Int where * >= 0;
sub acker (Pos $m, Pos $n) {
    state %cache;
    %cache{"$m:$n"}.defined and return %cache{"$m:$n"};
    say "$m, $n";
    unless $m { return $n + 1; }
    unless $n { return acker($m-1, 1); }
    my $v = acker($m-1, acker($m,$n-1));
    %cache{"$m:$n"} = $v;
    return $v;
}
say acker(3,2);
say now - INIT now;

# (3,2), no cache,      0.01749860
# (3,2), with cache,    0.0068402



