

class Jontest::Class { 
    method do_stuff { say "this is do_stuff" }
}

sub EXPORT {
    {
     '$var'   => 'one',
     '@array' => <one two three>,
     '%hash'  => { one => 'two', three => 'four' },
     '&doit'   => sub { say "this is doit" },
     'ShortName' => Jontest::Class
    }
}

