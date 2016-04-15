
constant max-speed = 4;

class Star {
    has Int $.max_x;
    has Int $.max_y;
    has Int $.x;
    has Int $.y;
    has Int $.speed;

    submethod BUILD(:$!max_x, :$!max_y) {
        $!x     = (^$!max_x).pick;          # random x from 0 to < screen-x
        $!y     = (^$!max_y).pick;          # random y from 0 to < screen-y
        $!speed = (1 .. max-speed).pick;    # random speed from 1 to max-speed (inclusive)
    }

    method move {
        $!x = ($!x >= $!speed) ?? $!x - $!speed !! $.max_x;
    }
}

