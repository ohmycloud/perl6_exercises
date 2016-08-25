#!/usr/bin/env perl6

use v6;

### Well, this looks handy.

my $start_num = 300;

say $start_num.base(2);     # 100101100
say $start_num.base(8);     # 454
say $start_num.base(10);    # 300 (derp)
say $start_num.base(16);    # 12C

